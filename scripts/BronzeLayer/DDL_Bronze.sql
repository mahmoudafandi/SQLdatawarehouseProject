/*
=============================================================
SQL Script: Create Bronze Schema Tables
=============================================================
Description:
- This script creates tables in the `bronze` schema for CRM, ERP, 
  and sales data.
- If a table already exists, it is dropped before creating a new one.
- Implements data constraints such as `CHECK` constraints for gender 
  and marital status.

Schema:
- **bronze.crm_cust_info**: Stores customer personal details.
- **bronze.crm_prd_info**: Stores product-related information.
- **bronze.crm_sales_details**: Contains sales transaction details.
- **bronze.erp_CUST_AZ12**: Stores customer records from ERP system.
- **bronze.erp_LOC_A101**: Stores customer location data.
- **bronze.erp_PX_CAT_G1V2**: Stores product category details.
=============================================================
*/

-- Drop table if it exists before creating a new one
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL  
    DROP TABLE bronze.crm_cust_info;  
CREATE TABLE bronze.crm_cust_info(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status VARCHAR(1) CHECK (cst_marital_status IN ('M', 'S')),
    cst_gndr VARCHAR(1) CHECK (cst_gndr IN ('M', 'F')),
    cst_create_date DATE
);

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL  
    DROP TABLE bronze.crm_prd_info;  
CREATE TABLE bronze.crm_prd_info(
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE  
);

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

IF OBJECT_ID('bronze.erp_CUST_AZ12', 'U') IS NOT NULL  
    DROP TABLE bronze.erp_CUST_AZ12;  
CREATE TABLE bronze.erp_CUST_AZ12(
    CID NVARCHAR(50),
    BDATE DATE,
    GEN NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_LOC_A101', 'U') IS NOT NULL  
    DROP TABLE bronze.erp_LOC_A101;  
CREATE TABLE bronze.erp_LOC_A101(
    CID NVARCHAR(50),
    CNTRY NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL  
    DROP TABLE bronze.erp_PX_CAT_G1V2;  
CREATE TABLE bronze.erp_PX_CAT_G1V2(
    ID NVARCHAR(50),
    CAT NVARCHAR(50),
    SUBCAT NVARCHAR(50),
    MAINTENANCE NVARCHAR(50)
);

