---Helper Table, to use SD module info to complete customer division SBS info for other tables which have missing values for node key.

select * from (
select
Cast(Cast(kunnr as int) as varchar) as kunnr,
vkorg,
vtweg,
spart,

/*Because this is to fill missing information, it makes assumption of using one SBS Division for customer. 
if more SBS Division is set for this customer, first come first selected */

Row_number() over (partition by concat(kunnr,vkorg,vtweg) order by spart) as Num,
CONCAT(Cast(Cast(kunnr as int) as varchar),'_',vkorg,'_',vtweg,'_',spart) as Nodekey
from ods_ext.sap_knvv) abc
where Num =1
