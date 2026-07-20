EXEC BRONZE.load_bronze

CREATE OR ALTER PROCEDURE BRONZE.load_bronze as
BEGIN
	
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY

		SET @batch_start_time = GETDATE();
		PRINT '===============================================================';
		PRINT 'LOADING BRONZE LAYER';
		PRINT '===============================================================';

		PRINT '---------------------------------------------------------------';
		PRINT 'LOADING CRM TABLES';
		PRINT '---------------------------------------------------------------';

		TRUNCATE TABLE BRONZE.crm_cust_info;

		BULK INSERT BRONZE.crm_cust_info
		FROM 'C:\Users\HP\Desktop\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'	
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);

		SET @start_time = GETDATE();
		TRUNCATE TABLE BRONZE.crm_prd_info;

		BULK INSERT BRONZE.crm_prd_info
		FROM 'C:\Users\HP\Desktop\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'	
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';

		TRUNCATE TABLE BRONZE.crm_sales_details;

		BULK INSERT BRONZE.crm_sales_details
		FROM 'C:\Users\HP\Desktop\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'	
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);

		PRINT '---------------------------------------------------------------';
		PRINT 'LOADING ERP TABLES';
		PRINT '---------------------------------------------------------------';

		TRUNCATE TABLE BRONZE.erp_CUST_AZ12;

		BULK INSERT BRONZE.erp_CUST_AZ12
		FROM 'C:\Users\HP\Desktop\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'	
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);

		TRUNCATE TABLE BRONZE.erp_LOC_A101;

		BULK INSERT BRONZE.erp_LOC_A101
		FROM 'C:\Users\HP\Desktop\SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'	
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);

		TRUNCATE TABLE BRONZE.erp_PX_CAT_G1V2;

		BULK INSERT BRONZE.erp_PX_CAT_G1V2
		FROM 'C:\Users\HP\Desktop\SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'	
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @batch_end_time = GETDATE();
		END TRY
	BEGIN CATCH
		PRINT '====================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT '====================================';
	END CATCH

END
