-- Update user email address in user module from jpogue@dmc.org to jmpogue@med.umich.edu
USE [CMS]
GO

UPDATE [CMS].[Users]
   SET [UserName] = 'jmpogue@med.umich.edu'
      ,[EmailAddress] = 'jmpogue@med.umich.edu'
      ,[UpdatedDate] = getdate()
      ,[UpdatedBy] = 'rranjit_00095711'
 WHERE [FirstName] = 'Jason' and [LastName] = 'Pogue'
GO


