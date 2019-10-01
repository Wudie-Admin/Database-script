-- This to delete duplicate contact of 'Mathai (Rajen) Koshy - ID# 6843' with Contact Id - 6843 )

use CMS_PROD_COPY
IF EXISTS (SELECT cms.persons.personid 
           FROM   cms.persons 
           WHERE  cms.persons.personid in (6843))
  BEGIN 
      BEGIN TRAN t1; 

      DELETE cms.committeememberships 
      FROM   cms.committeememberships c 
             INNER JOIN cms.persontypes pt 
                     ON pt.persontypeid = c.persontypeid 
      WHERE  pt.personid in (6843)

      PRINT 'deleted personid from committeememberships table' 

      DELETE cms.documentpermissions 
      FROM   cms.documentpermissions dp 
             INNER JOIN cms.persontypes pt 
                     ON pt.persontypeid = dp.persontypeid 
      WHERE  pt.personid in (6843)

      PRINT 'deleted personid from documentpermissions table' 

	  DELETE partycontactmechanisms 
      FROM   cms.partycontactmechanisms 
             INNER JOIN cms.persontypes 
                     ON cms.partycontactmechanisms.persontypeid = 
                        cms.persontypes.persontypeid 
             INNER JOIN cms.persons 
                     ON cms.persontypes.personid = cms.persons.personid 
      WHERE  cms.persons.personid in (6843)

      PRINT 'deleted personid from PartyContactMechanisms table' 

      DELETE partyaddresses 
      FROM   cms.partyaddresses 
             INNER JOIN cms.partypairs 
                     ON cms.partyaddresses.partypairid = 
                        cms.partypairs.partypairid 
             INNER JOIN cms.persontypes 
                     ON cms.partyaddresses.persontypeid = 
                        cms.persontypes.persontypeid 
                         OR cms.partypairs.ptyestablishedfromid = 
                            cms.persontypes.persontypeid 
                            AND cms.partypairs.ptyestablishedtoid = 
                                cms.persontypes.persontypeid 
             INNER JOIN cms.persons 
                     ON cms.persontypes.personid = cms.persons.personid 
      WHERE  cms.persons.personid in (6843)

      PRINT 'deleted personid from PartyAddresses table' 

      DELETE partypairs 
      FROM   cms.partypairs 
             INNER JOIN cms.persontypes 
                     ON cms.partypairs.ptyestablishedfromid = 
                        cms.persontypes.persontypeid 
                         OR cms.partypairs.ptyestablishedtoid = 
                            cms.persontypes.persontypeid 
             INNER JOIN cms.persons 
                     ON cms.persontypes.personid = cms.persons.personid 
      WHERE  cms.persons.personid in (6843)

      PRINT 'deleted personid from PartyPairs table' 

      DELETE cms.protocolroles 
      FROM   cms.protocolroles 
             INNER JOIN cms.persontypes 
                     ON cms.persontypes.persontypeid = 
                        cms.protocolroles.persontypeid 
             INNER JOIN cms.persons 
                     ON cms.persontypes.personid = cms.persons.personid 
      WHERE  cms.persons.personid in (6843)

      PRINT 'deleted persontypeid from protocolroles table' 

	   DELETE cms.UserRoles 
      FROM   cms.UserRoles 
			 INNER JOIN cms.Users
					 ON cms.UserRoles.UserId = cms.Users.UserId
             INNER JOIN cms.persontypes 
                     ON cms.persontypes.persontypeid = 
                        cms.Users.persontypeid 
             INNER JOIN cms.persons 
                     ON cms.persontypes.personid = cms.persons.personid 
      WHERE  cms.persons.personid in (6843)

      PRINT 'deleted persontypeid from userroles table' 

	  DELETE cms.Users 
      FROM   cms.Users 
             INNER JOIN cms.persontypes 
                     ON cms.persontypes.persontypeid = 
                        cms.Users.persontypeid 
             INNER JOIN cms.persons 
                     ON cms.persontypes.personid = cms.persons.personid 
      WHERE  cms.persons.personid in (6843)

      PRINT 'deleted persontypeid from users table' 


	  DELETE cms.MeetingInvitees
	  FROM cms.MeetingInvitees
	  INNER JOIN cms.persontypes on cms.PersonTypes.PersonTypeId = cms.MeetingInvitees.PersonTypeId
	  INNER JOIN cms.persons 
                     ON cms.persontypes.personid = cms.persons.personid
	 WHERE  cms.persons.personid in (6843)

	 PRINT 'deleted persontypeid from meetings table'

      DELETE persontypes 
      FROM   cms.persontypes 
             INNER JOIN cms.persons 
                     ON cms.persontypes.personid = cms.persons.personid 
      WHERE  cms.persons.personid in (6843)

      PRINT 'deleted personid from persontypes table' 

      DELETE cms.persondegrees 
      FROM   cms.persondegrees pd 
             INNER JOIN cms.persons p 
                     ON p.personid = pd.personid 
      WHERE  p.personid in (6843)

      PRINT 'deleted personid from persondegrees table' 

      DELETE cms.persons 
      FROM   cms.persons p 
      WHERE  p.personid in (6843)

	  PRINT 'deleted personid from persons table' 

      IF ( @@ERROR > 0 ) 
        BEGIN 
            ROLLBACK TRAN t1; 

            PRINT 'An error has occurred while deleting contact ID'; 
        END 
      ELSE 
        BEGIN 
            COMMIT TRAN t1; 

            PRINT 'deleted record successfully' 
        END 
  END 
ELSE 
  BEGIN 
      PRINT 'contact ID does not exists' 
  END 