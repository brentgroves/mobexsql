/* summary query */
select * from jobs where JOBNUMBER like '788%'-- descr like '%141%'
select * from items where itemnumber
select * from items
where ITEMNUMBER like '%166%' -- 16649
16691
16691
('485','500','1047','2020','2021','2022','2144','2563','2566','2573','2592','3024','3084','3144','3178','3179','3180','3683','5187','5188','7157','8488')
order by itemnumber
/* not in VM
('0000485'),
('0000500'),
--('0001047'),
('0002020'),
('0002021'),
('0002022'),
('0002144'),
('0002563'),
('0002566'),
('0002573'),
('0002592'),
('0003024'),
('0003084'),
('0003144'),
('0003178'),
('0003179'),
('0003180'),
('0003683'),
('0005187'),
('0005188'),
('007157'),
('008488'),
 */

SELECT dc.ITEMNUMBER 
from DrawerCompartmentItems dc 
where dc.VMID in (5,4) 
--and left(dc.ITEMNUMBER,1) = '0'
order by dc.ITEMNUMBER 

SELECT * from DrawerCompartmentItems dc where dc.ITEMNUMBER = '16845'
select * from items where right(ITEMNUMBER,1) = 'R'  --like '%[A-Z]%'  -- 7 items 
SELECT * from DrawerCompartmentItems dci where right(ITEMNUMBER,1) = 'R' --like '%[A-Z]%'
select 300758 pcn,vmi.VMID,
vmi.ITEMNUMBER,i.DESCR,
i.ITEMALIASNUMBER,i.SUPPLIERNUMBER,i.SUPPLIERPARTNUMBER,vmi.MINQTY,vmi.MAXQTY, 
case 
when dci.onhandqty is null then 0
else dci.onhandqty
end onhandqty,
case 
when dci.onhandqty is null then 0
else 1
end locationexist, 
i.UNITCOST,i.datecreated,i.DATELASTMODIFIED
--select count(*)
from items i -- 177
inner join VendingMachineItems vmi  -- 1 to many
on i.ITEMNUMBER = vmi.ITEMNUMBER 
--where vmi.VMID = 4  -- 158
--where vmi.VMID = 5  -- 286
left outer join 
(
  select dci.vmid,dci.itemnumber,sum(dci.qtycurrent) onhandqty 
  -- dci.picnumber,dci.drawerNumber,dci.compartmentnumber,
 -- select count(*) from (
 -- select count(*) cnt
  from DrawerCompartmentItems dci 
  group by dci.VMID,dci.ITEMNUMBER 
--  having dci.VMID = 4  -- 141
--  having dci.VMID = 5  -- 283 
--  ) s
) dci
on vmi.VMID = dci.VMID 
and vmi.ITEMNUMBER = dci.ITEMNUMBER  -- 962 
--where vmi.VMID = 4  -- 158
where vmi.VMID = 5  -- 286
and i.ITEMNUMBER like '%17165%'

select * from VendingMachineItems vmi  -- 1 to many
where vmi.ITEMNUMBER = '1001'

select * from DrawerCompartmentItems dci 
  select dci.vmid,dci.itemnumber,sum(dci.qtycurrent) onhandqty 
  -- dci.picnumber,dci.drawerNumber,dci.compartmentnumber,
  from DrawerCompartmentItems dci 
  group by dci.VMID,dci.ITEMNUMBER 
  having dci.VMID = 2  -- 141
and dci.ITEMNUMBER = '1001'

/*
 * 
 * 
"select 300758 pcn,vmi.VMID,
vmi.ITEMNUMBER,i.DESCR,
i.ITEMALIASNUMBER,i.SUPPLIERNUMBER,i.SUPPLIERPARTNUMBER,vmi.MINQTY,vmi.MAXQTY, 
case 
when dci.onhandqty is null then 0
else dci.onhandqty
end onhandqty,
case 
when dci.onhandqty is null then 0
else 1
end locationexist, 
i.UNITCOST,i.datecreated,i.DATELASTMODIFIED
--select count(*)
from items i -- 177
inner join VendingMachineItems vmi  -- 1 to many
on i.ITEMNUMBER = vmi.ITEMNUMBER -- 158
left outer join 
(
  select dci.vmid,dci.itemnumber,sum(dci.qtycurrent) onhandqty 
  -- dci.picnumber,dci.drawerNumber,dci.compartmentnumber,
  from DrawerCompartmentItems dci 
  group by dci.VMID,dci.ITEMNUMBER 
  having dci.VMID = 4  -- 148
) dci
on vmi.VMID = dci.VMID 
and vmi.ITEMNUMBER = dci.ITEMNUMBER  -- 1830 
where vmi.vmid = @[User::VMID]"  -- 158
 '"  +  @[User::VMID] + "'"

"SELECT '300758' PCN,
tlid,
VMID,
transtartdatetime,
TRANENDDATETIMe,
TRANSCODE,
USERNUMBER,
USERGROUP01, 
JOBNUMBER, 
ITEMNUMBER,
UNITCOST,
qty,
QTYNEW,
QTYONORDER,
ITEMGROUP, 
ITEMALIASNUMBER, 
SUPPLIERNUMBER,
SUPPLIERPARTNUMBER
FROM sps.dbo.TransactionLog
 where VMID in (4) 
and transcode = 'WN'
and jobnumber <> ''
and tranenddatetime > '"  +  @[User::LastImportTransactionLog] + "'"
