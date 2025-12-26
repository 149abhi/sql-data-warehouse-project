/*
================================================================================
DDL Script: Create Silver Tables
================================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables
    if they already exist.
    
    Run this script to redefine the DDL structure of 'silver' tables
================================================================================
*/

If Object_ID('silver.crm_cust_info', 'U') Is NOT NULL
	Drop Table silver.crm_cust_info;
Go

Create Table silver.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GetDate()
);
Go

If Object_ID('silver.crm_prd_info', 'U') Is NOT NULL
	Drop Table silver.crm_prd_info;
Go
Create Table silver.crm_prd_info(
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GetDate()
);
Go

If Object_ID('silver.crm_sales_details', 'U') Is NOT NULL
	Drop Table silver.crm_sales_details;
Go
Create Table silver.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt Date,
	sls_ship_dt Date,
	sls_due_dt Date,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GetDate()
);
Go

If Object_ID('silver.erp_CUST_AZ12', 'U') Is NOT NULL
	Drop Table silver.erp_CUST_AZ12;
Go
Create Table silver.erp_CUST_AZ12(
	CID NVARCHAR(50), 
	BDATE DATE,
	GEN NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GetDate()
);
Go

If Object_ID('silver.erp_LOC_A101', 'U') Is NOT NULL
	Drop Table silver.erp_LOC_A101;
Go
Create Table silver.erp_LOC_A101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GetDate()
);
Go

If Object_ID('silver.erp_PX_CAT_G1V2', 'U') Is NOT NULL
	Drop Table silver.erp_PX_CAT_G1V2;
Go
Create Table silver.erp_PX_CAT_G1V2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GetDate()
);
Go
