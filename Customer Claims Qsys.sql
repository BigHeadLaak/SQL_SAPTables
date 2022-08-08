---Customer Claim Data from Qsys on For Bearings,view is designed for Sales team so intercompany is not included

select
srqnr as 'Claim Number',
smandnr as 'Company Code',
Left(dtrqdatum,10) as 'Claim Date',
sfanr as 'Customer Number',
skostbez as 'Area',
sArtikelNr as 'Material Number',
dreklamiert as 'Del. Quantity',
sfarttext as 'Claim Area',
sfehlerbez as 'Claim Type',
sbemerkung2000 as 'Comment'

from Dbo.vw_qsy_v_2050_CustomerClaims
where nberechtigt = '1'

/*Exclude Intercompany claims*/
and sfanr not like '9000%'
and nlfdzusinfo3nr <> '1001'


UNION

select
srqnr as 'Claim Number',
smandnr as 'Company Code',
Left(dtrqdatum,10) as 'Claim Date',
sfanr as 'Customer Number',
skostbez as 'Area',
sArtikelNr as 'Material Number',
dreklamiert as 'Del. Quantity',
sfarttext as 'Claim Area',
sfehlerbez as 'Claim Type',
sbemerkung2000 as 'Comment'

from Dbo.vw_qsy_v_2020_CustomerClaims
where nberechtigt = '1'

/*Exclude Intercompany claims*/
and sfanr not like '9000%'
and nlfdzusinfo3nr <> '1001'

UNION

select
srqnr as 'Claim Number',
smandnr as 'Company Code',
Left(dtrqdatum,10) as 'Claim Date',
sfanr as 'Customer Number',
skostbez as 'Area',
sArtikelNr as 'Material Number',
dreklamiert as 'Del. Quantity',
sfarttext as 'Claim Area',
sfehlerbez as 'Claim Type',
sbemerkung2000 as 'Comment'

from Dbo.vw_qsy_v_2090_CustomerClaims
where nberechtigt = '1'

/*Exclude Intercompany claims*/
and sfanr not like '9000%'
and nlfdzusinfo3nr <> '1001'