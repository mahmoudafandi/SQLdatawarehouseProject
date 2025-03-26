/******************************************************************************************
-- Script Name  : Create_Silver_Tables.sql
-- Description  : This script drops and recreates tables in the "silver" schema to store 
--                transformed and cleansed data from the "bronze" schema.
--                These tables are part of the Data Warehouse (DWH) architecture.
-- Tables Created:
--  1. silver.crm_cust_info         - Stores customer information after cleansing.
--  2. silver.crm_prd_info          - Stores product details with formatted attributes.
--  3. silver.crm_sales_details     - Stores sales transactions with verified calculations.
--  4. silver.erp_CUST_AZ12         - Stores customer demographics from the ERP system.
--  5. silver.erp_LOC_A101          - Stores customer location details.
--  6. silver.erp_PX_CAT_G1V2       - Stores product category and maintenance info.
--
-- Notes:
--  - If tables exist, they are dropped before being recreated.
--  - Each table includes a `dwh_create_date` column to track data load timestamps.
******************************************************************************************/

-- Drop and create crm_cust_info table
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL  
    DROP TABLE silver.crm_cust_info;  
CREATE TABLE silver.crm_cust_info(
    cst_id INT,                          -- Unique customer ID
    cst_key NVARCHAR(50),                -- Customer key
    cst_firstname NVARCHAR(50),          -- First name (cleaned and trimmed)
    cst_lastname NVARCHAR(50),           -- Last name (cleaned and trimmed)
    cst_marital_status NVARCHAR(50),     -- Marital status (standardized)
    cst_gndr NVARCHAR(50),               -- Gender (standardized)
    cst_create_date DATE,                -- Original record creation date
    dwh_create_date DATETIME DEFAULT GETDATE()  -- DWH record creation timestamp
);

-- Drop and create crm_prd_info table
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL  
    DROP TABLE silver.crm_prd_info;  
CREATE TABLE silver.crm_prd_info(
    prd_id INT,                          -- Unique product ID
    cat_id NVARCHAR(50),                 -- Product category ID (extracted from prd_key)
    prd_key NVARCHAR(50),                -- Product key (cleansed)
    prd_nm NVARCHAR(50),                 -- Product name
    prd_cost INT,                         -- Product cost (default 0 if null)
    prd_line NVARCHAR(50),               -- Product line (standardized)
    prd_start_dt DATE,                    -- Start date of product availability
    prd_end_dt DATE,                      -- End date of product availability (calculated)
    dwh_create_date DATETIME DEFAULT GETDATE()  -- DWH record creation timestamp
);

-- Drop and create crm_sales_details table
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL  
    DROP TABLE silver.crm_sales_details;  
CREATE TABLE silver.crm_sales_details(
    sls_ord_num NVARCHAR(50),            -- Sales order number
    sls_prd_key NVARCHAR(50),            -- Product key associated with sale
    sls_cust_id INT,                     -- Customer ID who made the purchase
    sls_order_dt DATE,                    -- Order date (converted from raw data)
    sls_ship_dt DATE,                     -- Shipment date (converted from raw data)
    sls_due_dt DATE,                      -- Due date (converted from raw data)
    sls_sales INT,                        -- Total sales amount (validated)
    sls_quantity INT,                     -- Quantity of products sold
    sls_price INT,                        -- Price per unit (corrected if necessary)
    dwh_create_date DATETIME DEFAULT GETDATE()  -- DWH record creation timestamp
);

-- Drop and create erp_CUST_AZ12 table (ERP customer data)
IF OBJECT_ID('silver.erp_CUST_AZ12', 'U') IS NOT NULL  
    DROP TABLE silver.erp_CUST_AZ12;  
CREATE TABLE silver.erp_CUST_AZ12(
    CID NVARCHAR(50),                     -- Customer ID from ERP system
    BDATE DATE,                            -- Customer birthdate
    GEN NVARCHAR(50),                      -- Gender (standardized)
    dwh_create_date DATETIME DEFAULT GETDATE()  -- DWH record creation timestamp
);

-- Drop and create erp_LOC_A101 table (ERP customer location)
IF OBJECT_ID('silver.erp_LOC_A101', 'U') IS NOT NULL  
    DROP TABLE silver.erp_LOC_A101;  
CREATE TABLE silver.erp_LOC_A101(
    CID NVARCHAR(50),                      -- Customer ID (foreign key)
    CNTRY NVARCHAR(50),                    -- Country of residence
    dwh_create_date DATETIME DEFAULT GETDATE()  -- DWH record creation timestamp
);

-- Drop and create erp_PX_CAT_G1V2 table (ERP product category)
IF OBJECT_ID('silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL  
    DROP TABLE silver.erp_PX_CAT_G1V2;  
CREATE TABLE silver.erp_PX_CAT_G1V2(
    ID NVARCHAR(50),                       -- Unique category ID
    CAT NVARCHAR(50),                       -- Category name
    SUBCAT NVARCHAR(50),                    -- Subcategory name
    MAINTENANCE NVARCHAR(50),                -- Maintenance description
    dwh_create_date DATETIME DEFAULT GETDATE()  -- DWH record creation timestamp
);
