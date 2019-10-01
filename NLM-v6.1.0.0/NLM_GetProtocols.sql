CREATE PROCEDURE [CROMS].[NLM_GetProtocols]   
    @p_fromdate_in datetime,
    @p_todate_in datetime
AS

SELECT distinct 
	PRO_PROTOCOL_NUMBER AS PROTOCOL_NUMBER,
	replace(replace(PRO_ABBREVIATED_TITLE, '<br>', CHAR(10)), '<BR>', CHAR(10)) AS PROTOCOL_BRIEFTITLE,	
	replace(replace(PRO_FULL_PROTOCOL_TITLE, '<br>', CHAR(10)), '<BR>', CHAR(10)) AS PROTOCOL_OFFICIALTITLE,
	[CROMS].NLM_FN_formatIndIdeGrantor(PRO_PROTOCOL_NUMBER) AS IND_GRANTOR,
	MII_NUMBER AS IND_NUMBER,
	PII_IND_IDE_SERIAL_NUMBER AS IND_SERIALNUMBER,	
	ORG_NAME AS PROTOCOL_SPONSOR,	
	replace(replace(PRO_ABBR_PROTOCOL_DESCRIPTION, '<br>', CHAR(10)), '<BR>', CHAR(10)) PROTOCOL_BRIEFSUMMARY,
    replace(replace(PRO_FULL_PROTOCOL_DESCRIPTION, '<br>', CHAR(10)), '<BR>', CHAR(10)) PROTOCOL_DETAILEDDESC,
	PRO_OVERALL_RECRUIT_STATUS AS PROTOCOL_OVERALLSTATUS,
	PRO_PHASE AS PHASE,
	PRO_STUDY_TYPE AS STUDYTYPE,		 
	PQC_LAST_APPROVED_DATE AS VERIFICATIONDATE,
	SPD_STUDY_START_DATE AS STUDYSTARTDATE,	


	CASE
		WHEN DATEDIFF(day, GETDATE(), SPD_STUDY_START_DATE) <= 0 THEN 'Actual'
		WHEN DATEDIFF(day,  GETDATE(), SPD_STUDY_START_DATE) > 0 THEN 'Anticipated'			
		ELSE  '' 
	END AS STUDYSTARTDATETYPE,

	SPD_STUDY_COMPLETION_DATE AS STUDYCOMPDATE,
	PRO_PRIMARY_PURPOSE AS STUDYPURPOSE,
	PVR_ALLOCATION As STUDYALLOCATION,	
	PVR_INTERVENTIONAL_MODEL AS STUDYASSIGNMENT,	
	CAST(SPD_PATIENT_PART_DURATION_VALUE as VARCHAR(10)) + ' ' + CAST(SPD_PATIENT_PART_DUR_UNIT as VARCHAR(10)) As StudyDuration,	
	PVR_TIME_PERSPECTIVE AS STUDYTIMING,
	SPD_SEX AS GENDER,
	/*SER 730 : Enrollment values changes in NLM based on the Protocol Primary status */
	CASE 
		WHEN (PRO_PRIMARY_STATUS = 'Active-Enrollment Complete' OR PRO_PRIMARY_STATUS = 'Closed' 
				OR PRO_PRIMARY_STATUS = 'Completed' OR PRO_PRIMARY_STATUS = 'Terminated by Sponsor') THEN SPD_ACTUAL_ENROLL_NUMBER
		ELSE SPD_ANTICIPATED_ENROLL_NUMBER 
	END AS EXPECTEDENROLLMENT,
	CAST(SPD_MIN_AGE_OF_PARTICIPANTS_VALUE as VARCHAR(10))  +  ' ' + CAST(SPD_MIN_AGE_OF_PARTICIPANTS_UNIT  as VARCHAR(10)) as MINAGE,
	CAST(SPD_MAX_AGE_OF_PARTICIPANTS_VALUE  as VARCHAR(10)) +  ' ' + CAST(SPD_MAX_AGE_OF_PARTICIPANTS_UNIT  as VARCHAR(10)) As MAXAGE,
	CASE SPD_ACPT_HEALTHY_VOLUNTEERS_YN
		WHEN 'Y' THEN 'Yes'
		WHEN 'N' THEN 'No'
		ELSE  'None'  
	END AS HEALTHYVOLUNTEERSYN,

	
	CASE PII_IND_IDE_REQUIRED
		WHEN 'Unknown' THEN 'No'
		WHEN 'Yes' THEN 'Yes'		
		WHEN 'No' THEN 'No'			
		ELSE  'None' 
	END AS PROTOCOL_INDYN,		
	ISNULL(PVR_HAS_EXPANDED_ACCESS_YN,NULL) AS HASEXPANDEDACCESS,
	

	PVR_EXPANDED_ACCESS_STATUS AS EXPANDEDACCESSSTATUS,
	PVR_OBSERVATIONAL_STUDY_MODEL AS OBSERVATIONALSTUDYMODEL,	
	PVR_BIOSPECIMEN_RETENTION AS BIOSPECIMENRETENTION,
	PVR_BIOSPECIMEN_DESC AS BIOSPECIMENDESCRIPTION,	
	PVR_STUDY_POP_DESC AS STUDYPOPULATIONDESCRIPTION,
	PVR_SAMPLING_METHOD AS SAMPLINGMETHOD, 
    PEA_EXPANDED_ACCESS_TYPE AS HASEXPANDEDACCESSTYPE, 
	--PEA_EXPANDED_ACCESS_TYPE AS  HASEXPANDEDACCESSTYPE,  
	PVR_EXPANDED_ACCESS_NCT_NUMBER AS EXPANDEDACCESSNCTNUMBER, 	
	SPD_PRIMARY_COMPLETION_DATE AS PRIMARYCOMPLETIONDATE,
	SPD_PRIMARY_COMPLETION_DATE_TYPE AS PRIMARYCOMPLETIONDATETYPE,
	SPD_STUDY_COMPLETION_DATE_TYPE AS STUDYCOMPLETIONDATETYPE,
	SPD_WHY_STUDY_STOPPED AS WHY_STOPPED, --AB ICON jan 2017 update
	--SPD_GENDER_BASED_YN AS GENDERBASED,
    /*SER 730 : Enrollment values changes in NLM based on the Protocol Primary status */
	SPD_GENDER_BASED_YN AS GENDERBASED,
	SPD_GENDER_ELIGIBILITY_DESC AS ELIGIBILITYDESC,
	CASE 
		WHEN (PRO_PRIMARY_STATUS = 'Active-Enrollment Complete' OR PRO_PRIMARY_STATUS = 'Closed' 
			OR PRO_PRIMARY_STATUS = 'Completed' OR PRO_PRIMARY_STATUS = 'Terminated by Sponsor') THEN 'Actual' 
		ELSE 'Anticipated' 
	END AS ENROLLMENTTYPE,		
	CASE PRO_DEVICE_PRODUCT_APPROVED_YN
		WHEN 'Y' THEN 'Yes'
		WHEN 'N' THEN 'No'	
		ELSE 'None'  
	END AS DELAYEDPOSTING,
	CASE PVR_NUMBER_OF_ARMS 	
		WHEN 0 THEN NULL 
		ELSE PVR_NUMBER_OF_ARMS 
	END AS NUMBEROFARMS,	
	CASE PVR_NUMBER_OF_GROUPS 	
		WHEN 0 THEN NULL 
		ELSE PVR_NUMBER_OF_GROUPS  
	END AS NUMBEROFGROUPS, 
	PVR_MASKING_DESCRIPTION AS MASKING_DESCRIPTION	
FROM CROMS.PROTOCOLS PRO
	LEFT JOIN CROMS.PROTOCOL_VERSIONS PVR ON PVR_PRO_ID =  PRO_ID
	LEFT  join  [CROMS].[PROTOCOL_EXPANDED_ACCESS_TYPES] PEA on PEA_PVR_ID=PVR_ID            --PEA_PVR_ID=PVR_PRO_ID
	LEFT  JOIN (
		SELECT MAX(PQC_LAST_APPROVED_DATE) AS PQC_LAST_APPROVED_DATE ,PQC_PVR_ID 
		FROM CROMS.PROTOCOL_QC_CYCLES 
		WHERE PQC_LAST_APPROVED_DATE IS NOT NULL
		GROUP BY PQC_PVR_ID
	)
	 PQC  ON PQC_PVR_ID = PVR_ID	
	LEFT OUTER JOIN CROMS.STUDY_POPULATION_DATA SPD ON SPD_PVR_ID = PVR_ID	
	--create subquery table
	LEFT OUTER JOIN
		(SELECT *
		FROM CROMS.PROTOCOL_IND_IDE PII LEFT OUTER JOIN CROMS.MASTER_IND_IDE MII ON PII_MII_ID = MII_ID) PII_MII
		ON PRO_ID = PII_MII.PII_PRO_ID
	LEFT OUTER JOIN (SELECT COL_PRO_ID, COL_OTY_ID FROM CROMS.COLLABORATORS WHERE COL_LCT_ID = 7) COL
       ON COL_PRO_ID = PRO_ID
     LEFT OUTER JOIN CROMS.ORGANIZATION_TYPES on COL_OTY_ID = OTY_ID
     LEFT OUTER JOIN CROMS.ORGANIZATIONS on OTY_ORG_ID = ORG_ID
     LEFT JOIN CROMS.PROTOCOL_MASKED_ROLES PMR ON PVR_ID = PMR_PVR_ID
WHERE PRO_OVERALL_RECRUIT_STATUS  <> 'Unknown'
	AND PRO_NLM_SEND_YN = 'Y'
	AND PRO_NLM_SEND_WEEKLY_YN = 'Y'
	AND PVR_CURRENT_REVIEW_STATUS = 'Reviewed'  	
	AND PRO_LAST_CHANGED_DATE  >= @p_fromdate_in
	AND PRO_LAST_CHANGED_DATE  < @p_todate_in	
	AND PVR_CURRENT_VERSION_YN = 'Y' 
ORDER BY PRO_PROTOCOL_NUMBER



GO