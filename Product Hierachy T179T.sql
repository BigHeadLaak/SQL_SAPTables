--- Product Hierachy Table

/* Set up temporary table for tidied up product hierachy info from T179T */
with cte_T179T
AS(

/*English Priority 1 */
select * from(
select prodh,vtext,
ROW_Number() over (Partition by PRODH order by SPRAS) as Num
from ods_ext.sap_T179T
where SPRAS = 'E'

UNION 

/*German Priority 2 */
select prodh,vtext,
ROW_Number() over (Partition by PRODH order by SPRAS) as Num
from ods_ext.sap_T179T
where prodh not in (select prodh from ods_ext.sap_T179T where SPRAS = 'E')
and spras = 'D'

UNION

/*other languages select only one, no priority */
select prodh,vtext,
ROW_Number() over (Partition by PRODH order by SPRAS) as Num
from ods_ext.sap_T179T
where prodh not in (select prodh from ods_ext.sap_T179T where SPRAS in ( 'E','D'))
) as asd
where Num = 1
)



/*Use material master table MARA as root table */
select 
right(mara.matnr,9) as matnr,

---level 1
tb1.vtext as lvl1,

---level 2
case
when len(mara.prdha) = 5 then null 
else tb2.vtext 
end as lvl2,

---level 3
case 
when len(mara.prdha) = 5 then null 
when len(mara.prdha) = 10 then null 
else tb3.vtext
end as lvl3

from ods_ext.sap_mara as mara
left join cte_T179T as tb1 on tb1.Prodh = left(mara.prdha,5)
left join cte_T179T as tb2 on tb2.Prodh = left(mara.prdha,10)
left join cte_T179T as tb3 on tb3.Prodh = mara.prdha
where mara.prdha <> ''