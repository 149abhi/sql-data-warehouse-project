/*
================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
================================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
================================================================================
*/

Create or Alter Procedure Bronze.load_bronze AS 
Begin
	Declare @start_time DateTime, @end_time DateTime, @batch_start_time DateTime, @batch_end_time DateTime;
	Begin Try
		Set @batch_start_time = GETDATE();
		Print'===================================================';
		Print'Loading Bronze Layer';
		Print'===================================================';

		Print'---------------------------------------------------';
		Print'Loading CRM Tables'
		Print'---------------------------------------------------';

		Set @start_time = GETDATE();
		Print'>> Truncating Table: Bronze.crm_cust_info';
		Truncate Table Bronze.crm_cust_info;

		Print'Inserting data into: Bronze.crm_cust_info';
		Bulk Insert Bronze.crm_cust_info
		From 'C:\Users\abhis_p7w1ilb\OneDrive\Desktop\i\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		With (
		FirstRow = 2,
		FieldTerminator = ',',
		Tablock
		);
		Set @end_time = GETDATE();
		Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
        Print'----------------';

		Set @start_time = GETDATE();
		Print'>> Truncating Table: Bronze.crm_prd_info';
		Truncate Table Bronze.crm_prd_info;

		Print'Inserting data into:Bronze.crm_prd_info';
		Bulk Insert Bronze.crm_prd_info
		From 'C:\Users\abhis_p7w1ilb\OneDrive\Desktop\i\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		With (
		FirstRow = 2,
		FieldTerminator = ',',
		Tablock
		);
		Set @end_time = GETDATE();
		Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
        Print'----------------';

		Set @start_time = GETDATE();
		Print'>> Truncating Table: Bronze.crm_sales_details';
		Truncate Table Bronze.crm_sales_details;

		Print'Inserting data into:Bronze.crm_sales_details';
		Bulk Insert Bronze.crm_sales_details
		From 'C:\Users\abhis_p7w1ilb\OneDrive\Desktop\i\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		With (
		FirstRow = 2,
		FieldTerminator = ',',
		Tablock
		);
		Set @end_time = GETDATE();
		Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
        Print'----------------';

		Print'---------------------------------------------------';
		Print'Loading ERP Tables'
		Print'---------------------------------------------------';

		Set @start_time = GETDATE();
		Print'>> Truncating Table: Bronze.erp_CUST_AZ12';
		Truncate Table Bronze.erp_CUST_AZ12;

		Print'Inserting data into:Bronze.erp_CUST_AZ12';
		Bulk Insert Bronze.erp_CUST_AZ12
		From 'C:\Users\abhis_p7w1ilb\OneDrive\Desktop\i\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		With (
		FirstRow = 2,
		FieldTerminator = ',',
		Tablock
		);
		Set @end_time = GETDATE();
		Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
        Print'----------------';

		Set @start_time = GETDATE();
		Print'>> Truncating Table: Bronze.erp_LOC_A101';
		Truncate Table Bronze.erp_LOC_A101;

		Print'Inserting data into:Bronze.erp_LOC_A101';
		Bulk Insert Bronze.erp_LOC_A101
		From 'C:\Users\abhis_p7w1ilb\OneDrive\Desktop\i\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		With (
		FirstRow = 2,
		FieldTerminator = ',',
		Tablock
		);
		Set @end_time = GETDATE();
		Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
        Print'----------------';

		Set @start_time = GETDATE();
		Print'>> Truncating Table: Bronze.erp_PX_CAT_G1V2';
		Truncate Table Bronze.erp_PX_CAT_G1V2;

		Print'Inserting data into:Bronze.erp_PX_CAT_G1V2';
		Bulk Insert Bronze.erp_PX_CAT_G1V2
		From 'C:\Users\abhis_p7w1ilb\OneDrive\Desktop\i\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		With (
		FirstRow = 2,
		FieldTerminator = ',',
		Tablock
		);
		Set @end_time = GETDATE();
		Print'>> Load Duration:' + Cast(DateDiff(second, @start_time, @end_time)AS NVarChar) + ' seconds';
        Print'----------------';

		Set @batch_end_time = GETDATE();
		Print'==================================================================';
		Print'Loading Bronze layer is completed';
		Print'  - Total Load Duration:' + Cast(DateDiff(second, @batch_start_time, @batch_end_time)AS NVarChar) + ' seconds';
		Print'==================================================================';


	End Try
	Begin Catch
	Print'==================================================================';
	Print'Error Occured while loading Bronze layer';
	Print'Error Message'+ Error_Message();
	Print'Error Message'+ Cast(Error_Number() As Nvarchar);
	Print'Error Message'+ Cast(Error_State() As Nvarchar);
	Print'==================================================================';
	End Catch
End
