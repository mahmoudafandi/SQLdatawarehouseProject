/*
==========================================================================
Procedure Name: bronze.load_bronze
Description  : This stored procedure loads data into the Bronze layer of the
               Data Warehouse by performing the following steps:
               1. Truncating existing tables to ensure no duplicate data.
               2. Bulk inserting data from CSV files into respective tables.
               3. Logging time taken for each table load and overall execution time.
               4. Implementing error handling to capture any failures during execution.
               
Tables Affected:
               - bronze.crm_cust_info
               - bronze.crm_prd_info
               - bronze.crm_sales_details
               - bronze.erp_CUST_AZ12
               - bronze.erp_LOC_A101
               - bronze.erp_PX_CAT_G1V2

Error Handling:
               - Catches and prints error message, error number, and error state.
               - Ensures the transaction does not proceed on failure.
==========================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze 
AS
BEGIN 
    SET NOCOUNT ON;  -- Prevents unnecessary message output
    SET XACT_ABORT ON; -- Ensures transaction aborts on failure

    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start DATETIME, @batch_end DATETIME;

    BEGIN TRY 
        PRINT '============================================';
        PRINT 'Starting Bronze Layer Data Load';
        PRINT '=============================================';
        
        SET @batch_start = GETDATE();

        -- Load CRM Data
        PRINT '---------------------------------------------';
        PRINT 'Loading CRM Data';
        PRINT '---------------------------------------------';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info 
        FROM 'C:\Users\96650\Documents\SQL DWH salkini\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT 'Load duration (crm_cust_info): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load Product Information
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_prd_info;
        BULK INSERT bronze.crm_prd_info 
        FROM 'C:\Users\96650\Documents\SQL DWH salkini\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT 'Load duration (crm_prd_info): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load Sales Details
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details 
        FROM 'C:\Users\96650\Documents\SQL DWH salkini\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT 'Load duration (crm_sales_details): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load ERP Data
        PRINT '---------------------------------------------';
        PRINT 'Loading ERP Data';
        PRINT '---------------------------------------------';

        -- Load Customer Data from ERP
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_CUST_AZ12;
        BULK INSERT bronze.erp_CUST_AZ12 
        FROM 'C:\Users\96650\Documents\SQL DWH salkini\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT 'Load duration (erp_CUST_AZ12): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load Location Data from ERP
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_LOC_A101;
        BULK INSERT bronze.erp_LOC_A101 
        FROM 'C:\Users\96650\Documents\SQL DWH salkini\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT 'Load duration (erp_LOC_A101): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load Product Category Data from ERP
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
        BULK INSERT bronze.erp_PX_CAT_G1V2 
        FROM 'C:\Users\96650\Documents\SQL DWH salkini\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT 'Load duration (erp_PX_CAT_G1V2): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        SET @batch_end = GETDATE();
        PRINT '----------------------------------------------';
        PRINT 'Total Load Duration for Bronze Layer: ' + CAST(DATEDIFF(SECOND, @batch_start, @batch_end) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------------';

    END TRY 
    BEGIN CATCH 
        PRINT '---------------------------------------------';
        PRINT 'ERROR OCCURRED';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '---------------------------------------------';
    END CATCH 
END;
