---Material Description Table MAKT, tidied up

select * from(

/*English as Priority 1 */
select right(matnr,9) as matnr,maktx,
ROW_Number() over (Partition by matnr order by SPRAS) as Num
from ods_ext.sap_makt
where SPRAS = 'E'

UNION

/*German as Priority 2*/
select 
Right(matnr,9) as matnr,maktx,
ROW_Number() over (Partition by matnr order by SPRAS) as Num
from ods_ext.sap_makt
where matnr not in (select matnr from ods_ext.sap_makt where SPRAS = 'E')
and SPRAS = 'D'

UNION

/*Other Languages no Priority, select one */
select 
Right(matnr,9) as matnr,maktx,
ROW_Number() over (Partition by matnr order by SPRAS) as Num
from ods_ext.sap_makt
where matnr not in (select matnr from ods_ext.sap_makt where SPRAS not in ('D', 'E'))
) abc
where Num = 1