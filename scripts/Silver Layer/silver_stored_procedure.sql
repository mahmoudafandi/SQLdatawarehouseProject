/***************************************************************************************************
-- Stored Procedure: silver.load_silver  
-- Description:  
--   This procedure loads data from the Bronze layer to the Silver layer in a structured  
--   and optimized way. It ensures data consistency, cleans and normalizes values, and  
--   maintains referential integrity.  

-- Key Features:  
--   - Truncates target tables before inserting new data.  
--   - Deduplicates customer records based on the latest creation date.  
--   - Normalizes categorical fields such as marital status and gender.  
--   - Cleans and validates product keys and category information.  
--   - Ensures accurate sales calculations and handles null values.  
--   - Standardizes country codes and removes unwanted characters from location data.  
--   - Logs the processing time for each section to track performance.  

-- Error Handling:  
--   - Catches and logs errors with detailed messages, error numbers, and states.  

***************************************************************************************************/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start DATETIME, @batch_end DATETIME;

    BEGIN TRY
        PRINT '============================================';
        PRINT 'Loading Silver Layer';
        PRINT '============================================';

        SET @batch_start = GETDATE();

        -- Load CRM Customer Information
        PRINT '---------------------------------------------';
        PRINT 'Loading CRM Customer Information';
        PRINT 'Truncating silver.crm_cust_info before inserting';

        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.crm_cust_info;

        INSERT INTO silver.crm_cust_info (
            cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date
        )
        SELECT 
            cst_id,
            cst_key,
            TRIM(cst_firstname),
            TRIM(cst_lastname),
            CASE 
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'single' 
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'married'
                ELSE 'n/a'
            END AS cst_marital_status,
            CASE 
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END AS cst_gndr,  
            cst_create_date
        FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE flag_last = 1;

        SET @end_time = GETDATE();
        PRINT 'Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load CRM Product Information
        PRINT '---------------------------------------------';
        PRINT 'Loading CRM Product Information';
        PRINT 'Truncating silver.crm_prd_info before inserting';

        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.crm_prd_info;

        INSERT INTO silver.crm_prd_info (
            prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt
        )
        SELECT 
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
            prd_nm,
            ISNULL(prd_cost, 0) AS prd_cost,
            CASE 
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                ELSE 'n/a'
            END AS prd_line,
            CAST(prd_start_dt AS DATE),
            CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS prd_new_date
        FROM Bronze.crm_prd_info;

        SET @end_time = GETDATE();
        PRINT 'Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load ERP Customer Data
        PRINT '---------------------------------------------';
        PRINT 'Loading ERP Customer Data';
        PRINT 'Truncating silver.erp_CUST_AZ12 before inserting';

        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.erp_CUST_AZ12;

        INSERT INTO silver.erp_CUST_AZ12 (CID, BDATE, GEN)
        SELECT 
            CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid) - 4) ELSE cid END AS CID,
            CASE WHEN bdate > GETDATE() THEN NULL ELSE bdate END AS BDATE,
            CASE 
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a'
            END AS GEN
        FROM Bronze.erp_CUST_AZ12;

        SET @end_time = GETDATE();
        PRINT 'Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load ERP Location Data
        PRINT '---------------------------------------------';
        PRINT 'Loading ERP Location Data';
        PRINT 'Truncating silver.erp_LOC_A101 before inserting';

        SET @start_time = GETDATE();
        TRUNCATE TABLE silver.erp_LOC_A101;

        INSERT INTO silver.erp_LOC_A101 (CID, CNTRY)
        SELECT 
            REPLACE(CID, '-', '') AS CID,
            CASE 
                WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
                WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States of America'
                WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'n/a'
                ELSE TRIM(CNTRY)
            END AS CNTRY
        FROM Bronze.erp_LOC_A101;

        -- Load ERP Product Category Data
        PRINT '---------------------------------------------';
        PRINT 'Loading ERP Product Category Data';
        PRINT 'Truncating silver.erp_PX_CAT_G1V2 before inserting';

        TRUNCATE TABLE silver.erp_PX_CAT_G1V2;

        INSERT INTO silver.erp_PX_CAT_G1V2 (ID, CAT, SUBCAT, MAINTENANCE)
        SELECT ID, CAT, SUBCAT, MAINTENANCE
        FROM Bronze.erp_PX_CAT_G1V2;

        SET @batch_end = GETDATE();
        PRINT 'Total load duration: ' + CAST(DATEDIFF(SECOND, @batch_start, @batch_end) AS NVARCHAR) + ' seconds';
    
    END TRY
    BEGIN CATCH
        PRINT '---------------------------------------------';
        PRINT 'Error: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '---------------------------------------------';
    END CATCH;
END;
