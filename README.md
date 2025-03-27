# SQL Data Warehouse Project

## Overview
This SQL Data Warehouse (DWH) project is designed to integrate data from multiple sources (CRM and ERP), transform it into structured formats, and store it in a multi-layered architecture. The warehouse follows a **Bronze-Silver-Gold** layered approach to efficiently manage and cleanse data while ensuring analytical readiness.

---
## Data Flow and Architecture
The project implements an **ETL pipeline** that processes data from source systems and transforms it into a structured format for analytics and reporting.

### **1. Data Flow Overview**
![Data Flow](./mnt/data/Data%20flow.png)

- **Sources**: Data is extracted from **CRM** and **ERP** systems.
- **Bronze Layer**: Stores raw data from source systems without transformations.
- **Silver Layer**: Cleansed and standardized data, ready for analytics.
- **Gold Layer**: Fully transformed and aggregated data, optimized for business reporting.

---
## **Data Warehouse Schema (Star Schema)**
The data warehouse follows a **star schema** design for optimized querying and reporting.

### **2. Star Schema Structure**
![Star Schema](./mnt/data/star%20schema.png)

- **Fact Table**: `gold_fact_sales`
  - Stores transactional sales data.
  - Linked to customer and product dimensions.
- **Dimension Tables**:
  - `gold_dim_customers`: Stores customer attributes.
  - `gold_dim_products`: Stores product details.

---
## **Integration Flow**
The integration of CRM and ERP data is achieved through well-defined **joins and relationships**.

### **3. Data Integration Flow**
![Integration Flow](./mnt/data/integration%20flow.png)

- **Customer Data Integration**: Combines CRM customer info (`crm_cust_info`) with ERP customer details (`erp_CUST_AZ12`) and location (`erp_LOC_A101`).
- **Product Data Integration**: Links CRM product information (`crm_prd_info`) with ERP product category (`erp_PX_CAT_G1V2`).
- **Sales Transactions**: Sales data (`crm_sales_details`) links customers and products.

---
## **ETL Process and Procedures**
The ETL pipeline follows a structured **Extract, Transform, Load** process:

1. **Extract**:
   - Data is pulled from CRM and ERP sources into the Bronze layer.
   - Raw data is stored for traceability.

2. **Transform**:
   - Data is cleaned, standardized, and deduplicated in the Silver layer.
   - Joins are performed to integrate customer and product information.

3. **Load**:
   - The Gold layer stores final analytical tables (fact and dimensions) optimized for reporting.

---
## **Key SQL Procedures**
- **`bronze.load_bronze`**: Loads raw data from CSV files into the Bronze layer.
- **`silver.transform_data`**: Cleanses and standardizes data for analytics.
- **`gold.aggregate_data`**: Performs aggregation and final transformations for reporting.

---
## **Business Use Cases**
- **Customer Analytics**: Track customer demographics, locations, and purchasing behavior.
- **Sales Performance**: Analyze revenue, product categories, and sales trends.
- **Product Insights**: Understand product demand, pricing strategies, and inventory needs.

---
## **Conclusion**
This SQL Data Warehouse project provides an efficient and scalable **ETL and analytics solution**. By leveraging the **Bronze-Silver-Gold** architecture, the data warehouse ensures structured and clean data, enabling powerful business intelligence and reporting capabilities.

