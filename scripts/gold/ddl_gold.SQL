/*
================================================================================
DDL Script: Create Gold Views
================================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema)
    
    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
================================================================================
*/

-- ===========================================================================
-- Create Dimension: gold.dim_customers
-- ===========================================================================
If Object_id('gold.dim_customers','V') Is Not Null
	Drop View gold.dim_customers;
Go
Create View gold.dim_customers As 
Select 
	Row_Number() Over(Order By cst_id) As customer_key,
	ci.cst_id As customer_id,
	ci.cst_key As customer_number,
	ci.cst_firstname As first_name,
	ci.cst_lastname As last_name,
	la.cntry As country,
	ci.cst_marital_status As marital_status,
	Case When ci.cst_gndr != 'n/a' Then ci.cst_gndr -- CSM is the master for gender INFO
	     Else Coalesce(ca.gen, 'n/a')
		 End As gender,
	ca.bdate As birthdate,
	ci.cst_create_date As create_date	
From silver.crm_cust_info ci
Left Join silver.erp_cust_az12 ca
ON        ci.cst_key = ca.cid
Left Join silver.erp_loc_a101 la
ON        ci.cst_key = la.cid 
Go

-- ===========================================================================
-- Create Dimension: gold.dim_products
-- ===========================================================================
If Object_id('gold.dim_products','V') Is Not Null
	Drop View gold.dim_products;
Go
Create View gold.dim_products As 
Select 
	Row_Number() Over(Order By pn.prd_start_dt, pn.prd_key) As product_key,
	pn.prd_id As product_id,
	pn.prd_key As product_number,
	pn.prd_nm As product_name,
	pn.cat_id As category_id,
	pc.cat As category,
	pc.subcat as subcategory,
	pc.maintenance,
	pn.prd_cost As cost,
	pn.prd_line As product_line,
	pn.prd_start_dt As start_date
From silver.crm_prd_info pn
Left Join silver.erp_PX_CAT_G1V2 pc
	On pn.cat_id = pc.id
Where prd_end_dt Is Null --Filter out all historical data
Go

-- ===========================================================================
-- Create Dimension: gold.fact_sales
-- ===========================================================================
If Object_id('gold.fact_sales','V') Is Not Null
	Drop View gold.fact_sales;
Go
CREATE VIEW gold.fact_sales AS
SELECT
sd.sls_ord_num AS order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_quantity AS quanity,
sd.sls_price price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id
Go
