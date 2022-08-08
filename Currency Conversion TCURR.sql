--- Currency Conversion table in SAP
--- Warning! holiday and weekend currency rate not generated in this table, Hence holiday bookings need to use last available date currency


select
KURST,
FCURR,
TCURR,

/*Tidy Up date to date format */
CONVERT(DATE,CONCAT(LEFT((99999999 - GDATU),4),'/',SUBSTRING(CAST((99999999 - GDATU) as varchar(10)),5,2),'/',Right((99999999 - GDATU),2))) as Date,
UKURS as Rate
from ods_ext.sap_TCURR
where KURST = 'MIBA'
and FCURR = 'EUR'
/*only data after 2015 is added to decrease data size */
and YEAR(CONVERT(DATE,CONCAT(LEFT((99999999 - GDATU),4),'/',SUBSTRING(CAST((99999999 - GDATU) as varchar(10)),5,2),'/',Right((99999999 - GDATU),2)))) >=2015

UNION All

/* for easier calculation, exchange rate of 1 is added for euro to euro */

select
KURST,
FCURR,
'EUR' as TCURR,

/*Tidy Up date to date format */
CONVERT(DATE,CONCAT(LEFT((99999999 - GDATU),4),'/',SUBSTRING(CAST((99999999 - GDATU) as varchar(10)),5,2),'/',Right((99999999 - GDATU),2))) as Date,
1 as Rate
from ods_ext.sap_TCURR
where KURST = 'MIBA'
and FCURR = 'EUR'
and YEAR(CONVERT(DATE,CONCAT(LEFT((99999999 - GDATU),4),'/',SUBSTRING(CAST((99999999 - GDATU) as varchar(10)),5,2),'/',Right((99999999 - GDATU),2)))) >=2015