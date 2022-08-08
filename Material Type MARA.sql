--- Material Type from Material Master Table MARA
select * from (
select
Right(matnr,9) as matnr,
mtart,
ROW_NUmber() over (partition by matnr order by mtart) as Num
from ods_ext.sap_mara

/*Filter out text material numbers to tidy up */
where ISNUMERIC(MATNR) = 1
) abc
where Num = 1