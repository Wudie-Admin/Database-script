CREATE PROCEDURE [CROMS].[NLM_GetOutcomes]   
    @p_fromdate_in datetime,
    @p_todate_in datetime
AS   

SELECT DISTINCT PRO_PROTOCOL_NUMBER	AS PROTOCOL_NO,
	POU_OUTCOME_INDICATOR AS PRIMARY_INDICATOR_LOV,
	ISNULL(POU_OUTCOME_MEASURE,NULL) AS OUTCOME_MEASURE,
	ISNULL(POU_TIME_FRAME,NULL)  AS TIME_FRAME,
	ISNULL(POU_SAFETY_ISSUE, NULL) AS SAFETY_ISSUE,
	ISNULL(POU_OUTCOME_DESCRIPTION, NULL) AS OUTCOME_DESCRIPTION 
		
FROM CROMS.PROTOCOLS PRO
	INNER JOIN CROMS.PROTOCOL_VERSIONS PVR ON PRO_ID = PVR_PRO_ID
	INNER JOIN CROMS.PROTOCOL_OUTCOMES POU ON PVR_ID = POU_PVR_ID	
WHERE PRO_OVERALL_RECRUIT_STATUS  <> 'Unknown'
	AND PRO_NLM_SEND_YN = 'Y'
	AND PRO_NLM_SEND_WEEKLY_YN = 'Y'
	AND PVR_CURRENT_REVIEW_STATUS = 'Reviewed'
	AND PRO_LAST_CHANGED_DATE  >= @p_fromdate_in
	AND PRO_LAST_CHANGED_DATE  < @p_todate_in
	AND PVR_CURRENT_VERSION_YN = 'Y' 
ORDER BY PRO_PROTOCOL_NUMBER

GO