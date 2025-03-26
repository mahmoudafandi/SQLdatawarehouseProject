/*
=============================================================
SQL Script: Data Warehouse (DWH) Setup
Description: 
- Creates a new database named 'DWH' (originally 'DW').
- Defines three schemas: Bronze, Silver, and Gold.
- These schemas represent different layers in the data warehouse:
  - Bronze: Raw data ingestion layer.
  - Silver: Cleansed and transformed data.
  - Gold: Final, business-ready data.
=============================================================
*/

USE master;
CREATE DATABASE DW;

-- Rename database to DWH
ALTER DATABASE DW MODIFY NAME = DWH;

USE DWH;

-- Create schemas for Data Warehouse Layers
CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Gold;
GO

CREATE SCHEMA Silver;
GO
