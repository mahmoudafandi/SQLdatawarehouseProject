# SQLdatawarehouseProject
A **Data Warehouse (DWH)** built using **SQL Server** follows a structured approach to handling data from multiple sources, such as **CRM** and **ERP** systems, which provide data in CSV files. Using the **Medallion Architecture**, the data is ingested and stored in three layers: **Bronze, Silver, and Gold**.  

- The **Bronze layer** stores raw data in SQL tables without transformation.  
- The **Silver layer** cleans, standardizes, normalizes, and enriches the data, ensuring consistency.  
- The **Gold layer** transforms the data further by applying **aggregation, business logic, and data integration**, creating optimized views for analytics and reporting.  

Consumers, such as **BI tools, ad-hoc SQL queries, and Machine Learning models**, access the **Gold layer** for insights, making the DWH a powerful platform for decision-making. 🚀


![archi diagram](https://github.com/user-attachments/assets/38fa1839-70d7-4c5a-b44a-2c055b06adb6)
