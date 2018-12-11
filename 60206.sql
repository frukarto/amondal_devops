create or replace
FUNCTION                    FUNC_RESP_FOR_GET_BANDWIDTH
    (workflowResp IN VARCHAR2, inSan IN VARCHAR2)
    RETURN VARCHAR2
  IS
	getBandwidthResp VARCHAR2(4000):=workflowResp;
	workflowResp1 VARCHAR2(4000):=workflowResp;
    AnyTimeBandwidthAmount VARCHAR2(100):='';
	AnyTimeBandwidthUsed VARCHAR2(100):='';
    AnyTimeBandwidthAvailable VARCHAR2(100):='';
	BonusBandwidthAmount VARCHAR2(100):='';
	BonusBandwidthUsed VARCHAR2(100):='';
	BonusBandwidthAvailable VARCHAR2(100):='';
	TokenBandwidthAvailable VARCHAR2(100):='';
	CurrentZone VARCHAR2(100):='';
	RefillDayOfWeek VARCHAR2(100):='';
	RefillDayOfMonth VARCHAR2(100):='';
	RefillHourOfDay VARCHAR2(100):='';
	Gateway VARCHAR2(100):='';
	TimeZoneOffset VARCHAR2(100):='';
	Offst VARCHAR2(100):='';
  BEGIN
	workflowResp1 := replace(workflowResp,'}','');
	workflowResp1 := replace(workflowResp1,'{','');
	workflowResp1 := replace(workflowResp1,'[','');
	workflowResp1 := replace(workflowResp1,']','');
	workflowResp1 := '{' || workflowResp1 || '}';
	IF((INSTR(workflowResp1,'Time Out')>0) or (INSTR(workflowResp1,'cannot create snmp object')>0)) THEN
		getBandwidthResp := '{"status":"FAILED","ErrorCode":"1002","responseMsg":"Unable to determine Gateway for the terminal"}';
		RETURN getBandwidthResp;
	ELSIF(INSTR(workflowResp1,'HTTP URL')>0) THEN
		getBandwidthResp := '{"status":"FAILED","ErrorCode":"1003","responseMsg":"Unable to connect to WWNMS"}';
		RETURN getBandwidthResp;
  ELSIF(INSTR(workflowResp1,'errorCd":"1001')>0) THEN
    getBandwidthResp := '{"status":"FAILED","ErrorCode":"1001","responseMsg":"Either SAN is not valid or SAN is not active."}';
		RETURN getBandwidthResp;
	ELSE
		IF (workflowResp1 is not null or workflowResp1 != '') THEN

			AnyTimeBandwidthAmount := replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"overallcapacity"')+18,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"overallcapacity"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"overallcapacity"'),1)-(instr(lower(workflowResp1),'"overallcapacity"')+18))),'"','');

			AnyTimeBandwidthUsed := replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"overallusage"')+15,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"overallusage"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"overallusage"'),1)-(instr(lower(workflowResp1),'"overallusage"')+15))),'"','');

			IF(AnyTimeBandwidthAmount = '0') THEN
				AnyTimeBandwidthAvailable := '0';
			ELSE
				AnyTimeBandwidthAvailable := replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"overallcapacity"')+18,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"overallcapacity"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"overallcapacity"'),1)-(instr(lower(workflowResp1),'"overallcapacity"')+18))),'"','')-(replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"overallusage"')+15,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"overallusage"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"overallusage"'),1)-(instr(lower(workflowResp1),'"overallusage"')+15))),'"',''));
			END IF;

			BonusBandwidthAmount := replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"offpeakoverallcapacity"')+25,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"offpeakoverallcapacity"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"offpeakoverallcapacity"'),1)-(instr(lower(workflowResp1),'"offpeakoverallcapacity"')+25))),'"','');

			BonusBandwidthUsed := replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"offpeakoverallusage"')+22,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"offpeakoverallusage"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"offpeakoverallusage"'),1)-(instr(lower(workflowResp1),'"offpeakoverallusage"')+22))),'"','');

			IF(BonusBandwidthAmount = '0') THEN
				BonusBandwidthAvailable := '0';
			ELSE
				BonusBandwidthAvailable := replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"offpeakoverallcapacity"')+25,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"offpeakoverallcapacity"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"offpeakoverallcapacity"'),1)-(instr(lower(workflowResp1),'"offpeakoverallcapacity"')+25))),'"','')-(replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"offpeakoverallusage"')+22,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"offpeakoverallusage"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"offpeakoverallusage"'),1)-(instr(lower(workflowResp1),'"offpeakoverallusage"')+22))),'"',''));
			END IF;

			TokenBandwidthAvailable := replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"availtokens"')+14,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"availtokens"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"availtokens"'),1)-(instr(lower(workflowResp1),'"availtokens"')+14))),'"','');

			CurrentZone := replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"inpeakperiod"')+15,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"inpeakperiod"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"inpeakperiod"'),1)-(instr(lower(workflowResp1),'"inpeakperiod"')+15))),'"','');

			IF(CurrentZone = 'peak') THEN
				CurrentZone := 'Anytime';
			ELSIF (CurrentZone = 'off peak') THEN
				CurrentZone := 'Bonus';
			END IF;

			RefillDayOfWeek := replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"vupolstartdayofweek"')+22,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"vupolstartdayofweek"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"vupolstartdayofweek"'),1)-(instr(lower(workflowResp1),'"vupolstartdayofweek"')+22))),'"','');

			RefillDayOfMonth := replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"vupolstartdateofmonth"')+24,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"vupolstartdateofmonth"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"vupolstartdateofmonth"'),1)-(instr(lower(workflowResp1),'"vupolstartdateofmonth"')+24))),'"','');

			RefillHourOfDay := replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"vupolstarthour"')+17,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"vupolstarthour"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"vupolstarthour"'),1)-(instr(lower(workflowResp1),'"vupolstarthour"')+17))),'"','');

			Gateway := upper(substr(replace(substr(lower(workflowResp1),instr(lower(workflowResp1),'"gatewayid"')+12,(instr(lower(workflowResp1),case when (instr(lower(workflowResp1),',',instr(lower(workflowResp1),'"gatewayid"'),1))>0 then ',' else '}' end,instr(lower(workflowResp1),'"gatewayid"'),1)-(instr(lower(workflowResp1),'"gatewayid"')+12))),'"',''),0,3));

			TimeZoneOffset := replace(substr(workflowResp1,instr(workflowResp1,'"timezoneoffset"')+17,(instr(workflowResp1,case when (instr(workflowResp1,',',instr(workflowResp1,'"timezoneoffset"'),1))>0 then ',' else '}' end,instr(workflowResp1,'"timezoneoffset"'),1)-(instr(workflowResp1,'"timezoneoffset"')+17))),'"','');
			BEGIN
        Offst := trim(replace(replace(TimeZoneOffset,'UTC/GMT',''),'hours',''));

        select to_number(decode(substr(offst,1,1),'+',1,'-',-1,1))*(to_number(substr(offst,2,instr(offst,':')-2))*60+to_number(substr(offst,instr(offst,':')+1))) into TimeZoneOffset from dual;
      EXCEPTION
      WHEN OTHERS THEN
        TimeZoneOffset :='';
      END;

		END IF;
	END IF;

	If(TRIM(RefillDayOfMonth) is null) THEN
		select to_char(TRUNC(add_months(provision_dt, floor(months_between(sysdate, provision_dt))+1),'DDD'),'DD') into RefillDayOfMonth from site where san=inSan;
	END IF;
	--Construct response
		getBandwidthResp := '{"status":"PASSED","responseMsg":"Request processed successfully","AnyTimeBandwidthAmount":"'||AnyTimeBandwidthAmount||'","AnyTimeBandwidthUsed":"'||AnyTimeBandwidthUsed||'","AnyTimeBandwidthAvailable":"'||AnyTimeBandwidthAvailable||'","BonusBandwidthAmount":"'||BonusBandwidthAmount||'","BonusBandwidthUsed":"'||BonusBandwidthUsed||'","BonusBandwidthAvailable":"'||BonusBandwidthAvailable||'","TokenBandwidthAvailable":"'||TokenBandwidthAvailable||'","CurrentZone":"'||CurrentZone||'","RefillDayOfWeek":"'||RefillDayOfWeek||'","RefillDayOfMonth":"'||RefillDayOfMonth||'","RefillHourOfDay":"'||RefillHourOfDay||'","Gateway":"'||Gateway||'","TimeZoneOffset":"'||TimeZoneOffset||'"}';
    RETURN getBandwidthResp;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN getBandwidthResp;
  WHEN OTHERS THEN
    RETURN getBandwidthResp;
 END;