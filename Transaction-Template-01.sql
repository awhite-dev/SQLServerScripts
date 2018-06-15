	
	
	-- Prevent extra result sets from interferring with SELECT statements.
	SET NOCOUNT ON;
	
	-- Only use a local transaction if there are no other outside transactions being used.
	DECLARE @UseLocalTranscation BIT = 
		(
			CASE
				WHEN @@TRANCOUNT > 0 THEN 0
				ELSE 1
			END
		);	

	BEGIN TRY
		IF (@UseLocalTranscation = 1)
			BEGIN
				-- If any exception occurs, rollback entire transaction.
				SET XACT_ABORT ON;
				BEGIN TRANSACTION LocalTransaction;
			END
		BEGIN
		/**************************************************************************/
		
			PRINT N'Code goes here...';
		
		/**************************************************************************/
		END
		IF (@UseLocalTranscation = 1 && XACT_STATE() = 1)
			BEGIN
				-- Only commit the transaction if it's an a committable state.
				COMMIT TRANSACTION LocalTransaction;	
				
				PRINT N'';
				PRINT N'Transaction completed successfully.';
			END
	END TRY	
	
	BEGIN CATCH
		--	Capture the error into local variables.
		DECLARE 
			@ErrorMessage NVARCHAR(MAX),
			@ErrorSeverity NVARCHAR(50),
			@ErrorState NVARCHAR(50);
		SELECT	
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();
			
		--	Rollback the transaction only when it's a local transaction.
		IF (@UseLocalTranscation = 1 && XACT_STATE() <> 0)
			BEGIN
				ROLLBACK TRANSACTION LocalTransaction;
				
				PRINT N'';
				PRINT N'An error ocurred and the transaction was rolled back.';
				PRINT ERROR_MESSAGE()
			END		
			
		--	Notify the client of the exception.
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH