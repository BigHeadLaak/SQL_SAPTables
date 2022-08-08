--- Key Account Manager Information from TVGRT (Sales Group header)

select * from(

/* English Priority one */
select
spras,
vkgrp,
bezei,
Row_Number() over (partition by vkgrp order by spras) as Num
from ods_ext.sap_tvgrt
where SPRAS = 'E'

UNION

/*German Priority two */
select
spras,
vkgrp,
bezei,
Row_Number() over (partition by vkgrp order by spras) as Num
from ods_ext.sap_tvgrt
where SPRAS = 'D'
and vkgrp not in (select vkgrp from ods_ext.sap_tvgrt where spras = 'E')

UNION

/*One from other languages */
select
spras,
vkgrp,
bezei,
Row_Number() over (partition by vkgrp order by spras) as Num
from ods_ext.sap_tvgrt
where vkgrp not in (select vkgrp from ods_ext.sap_tvgrt where spras in ('E','D'))


) abc
where Num = 1