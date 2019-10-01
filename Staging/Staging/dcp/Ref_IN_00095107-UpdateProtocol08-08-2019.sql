/**script to update protocol for incident Ref:IN:00095107**/


UPDATE [DCP].[Protocol] 
SET StudyStatusKey = (SELECT StudyStatusId from [DCP].[StudyStatusLookUp] WHERE StudyStatus = 'Closed to Accrual'),
	LastChangedDate = GETDATE(),
	LastChangedUser = 'TRIAdmin'
where ProtocolNumber = 'UWI2016-07-01';


