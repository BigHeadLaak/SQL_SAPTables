
With CTE_KNA1 as (
select kunnr,name1 from(

/* include English descriptions first */
select 
kunnr,
NAME1,
spras,
Row_Number() over(partition by kunnr order by spras) as Num
from ods_ext.sap_kna1
where SPRAS = 'E'

UNION

/*include materials in German which have no English data */

select 
kunnr,
name1,
spras,
Row_Number() over(partition by kunnr order by spras) as Num
from ods_ext.sap_kna1
where kunnr not in (select kunnr from ods_ext.sap_kna1 where SPRAS = 'E')
and SPRAS = 'D'

UNION 

/*For other languages, only include one language description */

select 
kunnr,
name1,
spras,
Row_Number() over(partition by kunnr order by spras) as Num
from ods_ext.sap_kna1
where kunnr not in (select kunnr from ods_ext.sap_kna1 where SPRAS in ('E','D'))
) abc
where Num = 1), 

cte_KNVH AS(

select
CONCAT(knvh.kunnr,'-',knvh.vkorg,'-',knvh.vtweg,'-',knvh.spart) as ChildKey,
KNA1.name1 as Child,
datbi,
CONCAT(knvh.hkunnr,'-',knvh.hvkorg,'-',knvh.hvtweg,'-',knvh.hspart) as ParentKey,
KNA2.name1 as Parent
from ods_ext.sap_knvh as knvh
left join CTE_KNA1 as KNA1 on KNA1.kunnr = knvh.kunnr
left join CTE_KNA1 as KNA2 on KNA2.kunnr = knvh.hkunnr
where datbi > getdate()
and hkunnr <> ''
)



Select
tb2.CustKey,

Case 
when LvlInd = 4 then tb2.plus3
when LvlInd = 3 then tb2.plus2
when LvlInd = 2 then tb2.plus1
when LvlInd = 1 then tb2.CustKey
end as Lvl1,

Case 
when LvlInd = 4 then tb2.plus3t
when LvlInd = 3 then tb2.plus2t
when LvlInd = 2 then tb2.plus1t
when LvlInd = 1 then tb2.CustT
end as Lvl1t,

Case 
when LvlInd = 4 then tb2.plus2
when LvlInd = 3 then tb2.plus1
when LvlInd = 2 then tb2.CustKey
when LvlInd = 1 then null
end as Lvl2,

Case 
when LvlInd = 4 then tb2.plus2t
when LvlInd = 3 then tb2.plus1t
when LvlInd = 2 then tb2.CustT
when LvlInd = 1 then null
end as Lvl2t,

Case 
when LvlInd = 4 then tb2.plus1
when LvlInd = 3 then tb2.CustKey
when LvlInd = 2 then null
when LvlInd = 1 then null
end as Lvl3,

Case 
when LvlInd = 4 then tb2.plus1t
when LvlInd = 3 then tb2.CustT
when LvlInd = 2 then null
when LvlInd = 1 then null
end as Lvl3t,

Case 
when LvlInd = 4 then tb2.CustKey
when LvlInd = 3 then null
when LvlInd = 2 then null
when LvlInd = 1 then null
end as Lvl4,

Case 
when LvlInd = 4 then tb2.CustT
when LvlInd = 3 then null
when LvlInd = 2 then null
when LvlInd = 1 then null
end as Lvl4t


from(
Select 
tb1.CustKey,
tb1.CustT,
tb1.plus1,
tb1.plus1t,
tb1.plus2,
tb1.plus2t,
tb1.plus3,
tb1.plus3t,

Case
when tb1.plus3 is not null then 4
when tb1.plus3 is null and tb1.plus2 is not null then 3
when tb1.plus2 is null and tb1.plus1 is not null then 2
else 1
end as LvlInd

from (
select 
knvv3.CustKey,
knvv3.CustT,
knvv3.plus1,
knvv3.plus1t,
knvv3.plus2,
knvv3.plus2t,
knvh3.ParentKey as 'plus3',
knvh3.Parent as 'plus3t'

from(
select 
KNVV2.CustKey,
KNVV2.CustT,
KNVV2.plus1,
knvv2.plus1t,
knvh2.ParentKey as 'plus2',
knvh2.Parent as 'plus2t'

from(
select
CONCAT(KNVV.kunnr,'-',KNVV.vkorg,'-',KNVV.vtweg,'-',KNVV.spart) as CustKey,
kna1.name1 as CustT,
knvh1.ParentKey as 'plus1',
knvh1.Parent as 'plus1t'
from ods_ext.sap_KNVV as KNVV
LEFT JOIN cte_KNVH as knvh1 on knvh1.Childkey = CONCAT(KNVV.kunnr,'-',KNVV.vkorg,'-',KNVV.vtweg,'-',KNVV.spart)
LEFT JOIN CTE_KNA1 as kna1 on kna1.kunnr = knvv.kunnr
) as KNVV2

LEFT JOIN cte_KNVH as knvh2 on knvh2.Childkey = KNVV2.plus1) as knvv3
LEFT JOIN cte_KNVH as knvh3 on knvh3.Childkey = KNVV3.plus2
) as tb1
) as tb2
