  select rcv.TRANSACTION_ID,rcv.TRANSACTION_DATE,rcv.TRANSACTION_TYPE, 
  vend.VENDOR_NAME,vdet.VENDOR_SITE_CODE,po_head.SEGMENT1,po_line.LINE_NUM,mstr.SEGMENT1 as ITEM_CODE,po_line.ITEM_DESCRIPTION,
  po_line.UNIT_PRICE ,mstr.ITEM_TYPE,mstr.PRIMARY_UNIT_OF_MEASURE,po_head.CURRENCY_CODE,rcv.PRIMARY_QUANTITY,
  case when rcv.TRANSACTION_TYPE = 'RETURN TO VENDOR' then (rcv.QUANTITY*-1)
  when rcv.TRANSACTION_TYPE = 'RETURN TO RECEIVING' then (rcv.QUANTITY*-1)
 	else rcv.QUANTITY end as QTY_RCV,B.PACKING_SLIP
  from APPS.MEW_C_PO_HEADERS_ALL_ID_V  po_head
  LEFT JOIN APPS.MEW_C_PO_LINES_ALL_ID_V  po_line on po_head.PO_HEADER_ID=po_line.PO_HEADER_ID
  LEFT JOIN APPS.MEW_C_PO_DISTRIB_ALL_ID_V po_dist ON po_line.PO_LINE_ID=po_dist.PO_LINE_ID LEFT JOIN 
  APPS.MEW_C_MTL_SYSTEM_ITEMS_B_ID_V mstr ON 	mstr.INVENTORY_ITEM_ID=po_line.ITEM_ID	LEFT JOIN APPS.MEW_C_RCV_TRANSACTIONS_ID_V  rcv ON po_head.PO_HEADER_ID=rcv.PO_HEADER_ID 
  LEFT JOIN APPS.MEW_C_RCV_SHIPMENT_HEADER_ID_V B ON rcv.shipment_header_id = B.shipment_header_id, apps.MEW_C_AP_SUPPLIERS_ID_V vend,apps.MEW_C_AP_SUPPLIER_SITES_ID_V vdet, APPS.MEW_C_PO_LINE_LOC_ALL_ID_V po_loc
  where rcv.VENDOR_ID = vend.VENDOR_ID
  and rcv.VENDOR_SITE_ID = vdet.VENDOR_SITE_ID and  po_line.PO_LINE_ID=po_loc.PO_LINE_ID and  po_line.PO_LINE_ID=rcv.PO_LINE_ID AND mstr.ORGANIZATION_ID=222 
  and po_head.org_id=222  and rcv.USER_ENTERED_FLAG='Y' and rcv.TRANSACTION_TYPE = 'RETURN TO VENDOR'   and to_char(rcv.TRANSACTION_DATE,'mm-YYYY')=to_char(sysdate, 'mm-YYYY') --and  rcv.TRANSACTION_ID=3873192
  --and   po_head.SEGMENT1='PGM12362' 
  order by rcv.TRANSACTION_DATE DESC
  
  
  
  select * from APPS.MEW_C_MTL_SYSTEM_ITEMS_B_ID_V