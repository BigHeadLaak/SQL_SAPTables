


/*Bussiness Unit 1 Data*/

select
COPA.PALEDGER as CurrType,
COPA.BUKRS as CompanyCode,
COPA.WWVKK as KAM,
COPA.PERIO as FPeriod,
COPA.VTWEG as SBS,
CASE 
when CAST(COPA.KNDNR as int) = 0 then null 
else CAST(CAST(COPA.KNDNR as int) as varchar) 
end as CustomerNumber,
Right(COPA.ARTNR,9) as MaterialNumber,
COPA.FRWAE as OriCurrency,
SUM(COPA.vvgso+COPA.vvgsb-COPA.vvbab+COPA.vvfah) as Revenue,
SUM(COPA.vvgso+COPA.vvgsb-COPA.vvbab+COPA.vvfah -COPA.vvz15 - COPA.vvz10 - COPA.vvznn - COPA.vvsva-COPA.vvz12 - COPA.vvsvb - COPA.vvsvd - COPA.vvsve - COPA.vvsvf) as CMI,
SUM(COPA.vvgsm) as Quantity,

/* Tydy up any data line that does not have SBS or Division, use data from KNVV to fill, so that node for customer Hierachy can be used */

CASE
WHEN CAST(COPA.KNDNR as int) = 0 then null
else CONCAT( CAST(COPA.KNDNR as int),'_',COPA.BUKRS,'_',COPA.vtweg,'_',COPA.spart) 
end as NodeKey,

/* set ACT column for later merging with Planning Data */
'ACT' as ValType

from ods_ext.sap_CE14000 as COPA

where COPA.GJAHR >=2015
and COPA.PALEDGER in ('01','02')

Group By
COPA.BUKRS,
COPA.WWVKK,
COPA.PERIO,
COPA.VTWEG,
COPA.KNDNR,
COPA.ARTNR,
COPA.FRWAE,
COPA.REC_WAERS,
COPA.spart,
COPA.PALEDGER

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Business Unit 2 Data */


UNION All

select 
COPA.PALEDGER as CurrType,
COPA.BUKRS as CompanyCode,
COPA.WWVKK as KAM,
COPA.PERIO as FPeriod,
COPA.VTWEG as SBS,
CASE 
when CAST(COPA.KNDNR as int) = 0 then null 
else CAST(CAST(COPA.KNDNR as int) as varchar)
end as CustomerNumber,
Right(COPA.ARTNR,9) as MaterialNumber,
COPA.FRWAE as OriCurrency,
SUM(COPA.vvgso+COPA.vvgsb-COPA.vvbab) as Revenue,
SUM(COPA.VVGSB + COPA.VVGSO - COPA.VVBAB + COPA.VVCDB - COPA.VVPRO - COPA.VVFAJ - COPA.VVFRT - COPA.VVINS - COPA.VVZ15 - COPA.VVZ10- COPA.VVZNN - COPA.VVSVA - COPA.VVZ12 - COPA.VVSVB - COPA.VVSVD - COPA.VVBAD - COPA.VVBAC - COPA.VVBAF - COPA.VVBAE - COPA.VVBAH - COPA.VVBAG - COPA.VVBAJ - COPA.VVBAI - COPA.VVMAN) as CMI,
SUM(COPA.vvgsm) as Quantity,

/* Tydy up any data line that does not have SBS or Division, use data from KNVV to fill, so that node for customer Hierachy can be used */


CASE
WHEN CAST(COPA.KNDNR as int) = 0 then null
else CONCAT( CAST(COPA.KNDNR as int),'_',COPA.BUKRS,'_',COPA.vtweg,'_',COPA.spart) 
end as NodeKey,

/* set ACT column for later merging with Planning Data */

'ACT' as ValType

from ods_ext.sap_CE12000 as COPA

where COPA.GJAHR >=2015
and COPA.PALEDGER in ('01','02')

Group By
COPA.BUKRS,
COPA.WWVKK,
COPA.PERIO,
COPA.VTWEG,
COPA.KNDNR,
COPA.ARTNR,
COPA.FRWAE,
COPA.REC_WAERS,
COPA.spart,
COPA.PALEDGER

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Business Unit 3 Data*/

UNION All

select
COPA.PALEDGER as CurrType,
COPA.BUKRS as CompanyCode,
COPA.WWVKK as KAM,
COPA.PERIO as FPeriod,
COPA.VTWEG as SBS,
CASE 
when CAST(COPA.KNDNR as int) = 0 then null 
else CAST(CAST(COPA.KNDNR as int) as varchar)
end as CustomerNumber,
Right(COPA.ARTNR,9) as MaterialNumber,
COPA.FRWAE as OriCurrency,
SUM(COPA.vvgso+COPA.vvgsb-COPA.vvbab) as Revenue,
SUM(COPA.vvgso+COPA.vvgsb-COPA.vvbab -COPA.vvz15 - COPA.vvz10 - COPA.vvznn - COPA.vvsva-COPA.vvz12 - COPA.vvsvb - COPA.vvsvd - COPA.vvsve - COPA.vvsvf) as CMI,
SUM(COPA.vvgsm) as Quantity,

/* Tydy up any data line that does not have SBS or Division, use data from KNVV to fill, so that node for customer Hierachy can be used */

CASE
WHEN CAST(COPA.KNDNR as int) = 0 then null
else CONCAT( CAST(COPA.KNDNR as int),'_',COPA.BUKRS,'_',COPA.vtweg,'_',COPA.spart) 
end as NodeKey,

/* set ACT column for later merging with Planning Data */
'ACT' as ValType


from ods_ext.sap_CE13000 as COPA

where COPA.GJAHR >=2015
and COPA.PALEDGER in ('01','02')

Group By
COPA.BUKRS,
COPA.WWVKK,
COPA.PERIO,
COPA.VTWEG,
COPA.KNDNR,
COPA.ARTNR,
COPA.FRWAE,
COPA.REC_WAERS,
COPA.spart,
COPA.PALEDGER
