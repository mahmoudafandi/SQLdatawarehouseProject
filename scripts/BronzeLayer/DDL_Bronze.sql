/***************************************************************************************************
-- Script: Bronze Layer Table Creation  
-- Description:  
--   This script creates the Bronze layer tables, which serve as the raw data staging area.  
--   The Bronze layer holds unprocessed and minimally transformed data from various sources.  
--  
-- Key Features:  
--   - Drops tables if they already exist to ensure a fresh structure.  
--   - Defines data types appropriate for staging raw data.  
--   - Ensures compatibility for further processing in the Silver layer.  
--   - Maintains referential integrity by organizing data into logical tables.  
--  
-- Tables Created:  
--   - bronze.crm_cust_info: Holds customer details from CRM.  
--   - bronze.crm_prd_info: Contains product information from CRM.  
--   - bronze.crm_sales_details: Stores raw sales transaction details.  
--   - bronze.erp_CUST_AZ12: Contains ERP system customer information.  
--   - bronze.erp_LOC_A101: Stores customer location details.  
--   - bronze.erp_PX_CAT_G1V2: Contains product category mappings.  
--  
-- Note:  
--   - INT fields are used for IDs and numeric values where applicable.  
--   - NVARCHAR is used for text-based fields to support variable-length data.  
--   - Date and datetime fields are used to capture time-sensitive data.  
***************************************************************************************************/

-- Drop and Create CRM Customer Information Table
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL  
    DROP TABLE bronze.crm_cust_info;  
CREATE TABLE bronze.crm_cust_info(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE
);

-- Drop and Create CRM Product Information Table
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL  
    DROP TABLE bronze.crm_prd_info;  
CREATE TABLE bronze.crm_prd_info(
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME  
);

-- Drop and Create CRM Sales Details Table
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL  
    DROP TABLE bronze.crm_sales_details;  
CREATE TABLE bronze.crm_sales_details(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

-- Drop and Create ERP Customer Data Table
IF OBJECT_ID('bronze.erp_CUST_AZ12', 'U') IS NOT NULL  
    DROP TABLE bronze.erp_CUST_AZ12;  
CREATE TABLE bronze.erp_CUST_AZ12(
    CID NVARCHAR(50),
    BDATE DATE,
    GEN NVARCHAR(50)
);

-- Drop and Create ERP Location Data Table
IF OBJECT_ID('bronze.erp_LOC_A101', 'U') IS NOT NULL  
    DROP TABLE bronze.erp_LOC_A101;  
CREATE TABLE bronze.erp_LOC_A101(
    CID NVARCHAR(50),
    CNTRY NVARCHAR(50)
);

-- Drop and Create ERP Product Category Table
IF OBJECT_ID('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL  
    DROP TABLE bronze.erp_PX_CAT_G1V2;  
CREATE TABLE bronze.erp_PX_CAT_G1V2(
    ID NVARCHAR(50),
    CAT NVARCHAR(50),
    SUBCAT NVARCHAR(50),
    MAINTENANCE NVARCHAR(50)
);


