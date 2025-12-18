/*
================================================================================
DDL Script: Create Bronze Tables
================================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    
    Run this script to redefine the DDL structure of 'bronze' tables
================================================================================
*/

If Object_ID('bronze.crm_cust_info', 'U') Is NOT NULL
	Drop Table bronze.crm_cust_info;
Go

Create Table bronze.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);
Go

If Object_ID('bronze.crm_prd_info', 'U') Is NOT NULL
	Drop Table bronze.crm_prd_info;
Go
Create Table bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);
Go

If Object_ID('bronze.crm_sales_details', 'U') Is NOT NULL
	Drop Table bronze.crm_sales_details;
Go
Create Table bronze.crm_sales_details(
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
Go

If Object_ID('bronze.erp_CUST_AZ12', 'U') Is NOT NULL
	Drop Table bronze.erp_CUST_AZ12;
Go
Create Table bronze.erp_CUST_AZ12(
	CID NVARCHAR(50), 
	BDATE DATE,
	GEN NVARCHAR(50)
);
Go

If Object_ID('bronze.erp_LOC_A101', 'U') Is NOT NULL
	Drop Table bronze.erp_LOC_A101;
Go
Create Table bronze.erp_LOC_A101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50)
);
Go

If Object_ID('bronze.erp_PX_CAT_G1V2', 'U') Is NOT NULL
	Drop Table bronze.erp_PX_CAT_G1V2;
Go
Create Table bronze.erp_PX_CAT_G1V2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50)
);
Go
