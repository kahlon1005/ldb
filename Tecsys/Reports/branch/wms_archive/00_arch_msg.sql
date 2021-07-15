USE master;  
GO  
EXEC sp_addmessage @msgnum = 70001, @severity = 16, 
	@msgtext = N'Insert failed for table %s ...', @replace = replace,
	@lang = 'us_english';  
GO  
