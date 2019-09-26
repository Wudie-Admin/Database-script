CREATE TABLE [dbo].[curreny]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [currency_code] CHAR(10) NOT NULL, 
    [Currency_name] NVARCHAR(50) NULL, 
    [Currency_Description] NVARCHAR(50) NULL
)
