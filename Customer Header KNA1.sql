
--- Customer Description Table, Set English as priority one, German as priority two, then other languages

select * from(

/* include English descriptions first */
select 
CAST(CAST(kunnr as int) as varchar ) as kunnr,
NAME1,
spras,
Row_Number() over(partition by kunnr order by spras) as Num
from ods_ext.sap_kna1
where SPRAS = 'E'

UNION

/*include materials in German which have no English data */

select 
CAST(CAST(kunnr as int) as varchar ) as kunnr,
name1,
spras,
Row_Number() over(partition by kunnr order by spras) as Num
from ods_ext.sap_kna1
where kunnr not in (select kunnr from ods_ext.sap_kna1 where SPRAS = 'E')
and SPRAS = 'D'

UNION 

/*For other languages, only include one language description */

select 
CAST(CAST(kunnr as int) as varchar ) as kunnr,
name1,
spras,
Row_Number() over(partition by kunnr order by spras) as Num
from ods_ext.sap_kna1
where kunnr not in (select kunnr from ods_ext.sap_kna1 where SPRAS in ('E','D'))
) abc
where Num = 1




