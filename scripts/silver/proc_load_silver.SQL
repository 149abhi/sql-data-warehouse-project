/*
================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
================================================================================
Script Purpose:
    This stored procedure performs the ETL(Extract, Transfer, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.
    
It performs the following actions: 
    - Truncates the silver tables.
    - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver.load_silver;
================================================================================
*/
Create or Alter Procedure Silver.load_silver As 
Begin
	Declare @start_time DateTime, @end_time DateTime, @batch_start_time DateTime, @batch_end_time DateTime;
    Begin Try
			Set @batch_start_time = GETDATE();
			Print'===================================================';
			Print'Loading Silver Layer';
			Print'===================================================';

			Print'---------------------------------------------------';
			Print'Loading CRM Tables'
			Print'---------------------------------------------------';

		-- Loading silver.crm_cust_info
		Set @start_time = GETDATE();
		Print'>> Truncating Table: silver.crm_cust_info'
		Truncate Table silver.crm_cust_info
		Print'>> Inserting Data Into: silver.crm_cust_info'
		Insert Into silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
		)
		Select 
		cst_id,
		cst_key,
		Trim(cst_firstname) As cst_firstname,
		Trim(cst_lastname) As cst_lastname,
		Case When Upper(Trim(cst_marital_status)) = 'S' Then 'Single'
			 When Upper(Trim(cst_marital_status)) = 'M' Then 'Married'
			 Else 'n/a'
		End cst_marital_status,
		Case When Upper(Trim(cst_gndr)) = 'F' Then 'Female'
			 When Upper(Trim(cst_gndr)) = 'M' Then 'Male'
			 Else 'n/a'
		End cst_gndr,
		cst_create_date
		From (
		Select *,
		ROW_NUMBER() Over(Partition By cst_id Order By cst_create_date DESC) As flag_last
		From Bronze.crm_cust_info
		Where cst_id IS Not Null
		) t Where flag_last = 1;
		Set @end_time = GETDATE();
			Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
			Print'----------------';

		-- Loading silver.crm_prd_info
		Set @start_time = GETDATE();
		Print'>> Truncating Table: silver.crm_prd_info'
		Truncate Table silver.crm_prd_info
		Print'>> Inserting Data Into: silver.crm_prd_info'
		Insert Into silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)
		Select prd_id,
		Replace(SUBSTRING(prd_key, 1, 5), '-', '_') As cat_id, 
		SUBSTRING(prd_key, 7, Len(prd_key)) As prd_key,
		prd_nm,
		ISNULL(prd_cost, 0) As prd_cost,
		Case Upper(Trim(prd_line)) 
			 When 'M' Then 'Mountain'
			 When 'R' Then 'Road'
			 When 'S' Then 'Other Sales'
			 When 'T' Then 'Touring'
			 Else 'n/a'
		End As prd_line,
		CAST(prd_start_dt As Date) As prd_start_dt,
		CAST(LEAD(prd_start_dt) Over(Partition By prd_key Order By prd_start_dt) -1 As Date) As prd_end_dt
		From Bronze.crm_prd_info
		Set @end_time = GETDATE();
			Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
			Print'----------------';

		-- Loading silver.crm_sales_details
		Set @start_time = GETDATE();
		Print'>> Truncating Table: silver.crm_sales_details'
		Truncate Table silver.crm_sales_details
		Print'>> Inserting Data Into: silver.crm_sales_details'
		Insert Into silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		Select
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		Case When sls_order_dt = 0 Or LEN(sls_order_dt) != 8 Then Null
			 Else Cast(Cast(sls_order_dt As varchar) As Date)
		End As sls_order_dt,
		Case When sls_ship_dt = 0 Or LEN(sls_ship_dt) != 8 Then Null
			 Else Cast(Cast(sls_ship_dt As varchar) As Date)
		End As sls_ship_dt,
		Case When sls_due_dt = 0 Or LEN(sls_due_dt) != 8 Then Null
			 Else Cast(Cast(sls_due_dt As varchar) As Date)
		End As sls_due_dt,
		Case When sls_sales Is Null Or sls_sales <= 0 Or sls_sales != sls_quantity * ABS(sls_price)
				Then sls_quantity * ABS(sls_price)
			 Else sls_sales
		End As sls_sales,
		sls_quantity,
		Case When sls_price Is Null Or sls_price <= 0
				Then sls_sales/NUllIf(sls_quantity, 0)
			 Else sls_price
		End As sls_price
		From Bronze.crm_sales_details
		Set @end_time = GETDATE();
			Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
			Print'----------------';

		Print'---------------------------------------------------';
		Print'Loading ERP Tables'
		Print'---------------------------------------------------';

		-- Loading silver.erp_CUST_AZ12
		Set @start_time = GETDATE();
		Print'>> Truncating Table: silver.erp_CUST_AZ12'
		Truncate Table silver.erp_CUST_AZ12
		Print'>> Inserting Data Into: silver.erp_CUST_AZ12'
		Insert Into silver.erp_CUST_AZ12(
		cid,
		bdate,
		gen)
		Select 
		Case When cid LIKE 'NAS%' Then SUBSTRING(cid, 4, LEN(cid))
			 Else cid
		End As cid,
		Case When bdate > GETDATE() Then Null
			 Else bdate
		End As bdate,
		Case When Upper(Trim(gen)) IN ('F', 'FEMALE') Then 'Female'
			 When Upper(Trim(gen)) IN ('M', 'MALE') Then 'Male'
			 Else 'n/a'
		End As gen
		From Bronze.erp_CUST_AZ12
		Set @end_time = GETDATE();
			Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
			Print'----------------';

		-- Loading silver.erp_LOC_A101
		Set @start_time = GETDATE();
		Print'>> Truncating Table: silver.erp_LOC_A101'
		Truncate Table silver.erp_LOC_A101
		Print'>> Inserting Data Into: silver.erp_LOC_A101'
		Insert Into silver.erp_LOC_A101(
		cid,
		cntry)
		Select 
		Replace(cid, '-', '') As cid,
		Case When Trim(cntry) = 'DE' Then 'Germany'
			 When Trim(cntry) IN('US', 'USA') Then 'United States'
			 When Trim(cntry) = '' OR cntry IS Null Then 'n/a'
			 Else Trim(cntry)
		End As cntry
		From Bronze.erp_LOC_A101;
		Set @end_time = GETDATE();
			Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
			Print'----------------';

		-- Loading silver.erp_PX_CAT_G1V2
		Set @start_time = GETDATE();
		Print'>> Truncating Table: silver.erp_PX_CAT_G1V2'
		Truncate Table silver.erp_PX_CAT_G1V2
		Print'>> Inserting Data Into: silver.erp_PX_CAT_G1V2'
		Insert Into silver.erp_PX_CAT_G1V2(
		id,
		cat,
		subcat,
		maintenance)
		Select id,
		cat,
		subcat,
		maintenance
		From Bronze.erp_PX_CAT_G1V2
		Set @end_time = GETDATE();
			Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
			Print'----------------';
	End Try
	Begin Catch
	Print'==================================================================';
	Print'Error Occured while loading Silver layer';
	Print'Error Message'+ Error_Message();
	Print'Error Message'+ Cast(Error_Number() As Nvarchar);
	Print'Error Message'+ Cast(Error_State() As Nvarchar);
	Print'==================================================================';
	End Catch
END
