select 
itm.SEGMENT1,
itm.DESCRIPTION,
pln.item_type,
pln.quantity,
pln.month,
pln.CREATION_DATE
from  apps.MEW_MRP_DAY_PRD_PLAN_HDR_ID_V pln,APPS.MEW_C_MTL_SYSTEM_ITEMS_B_ID_V itm where pln.INVENTORY_ITEM_ID=itm.INVENTORY_ITEM_ID 
and itm.ORGANIZATION_ID=222 and
pln.ORGANIZATION_ID=222 and  to_char(pln.CREATION_DATE,'mm-YYYY')=to_char(sysdate, 'mm-YYYY')