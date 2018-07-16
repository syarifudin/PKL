select vend.VENDOR_NAME,vdet.VENDOR_SITE_CODE,po_head.AUTHORIZATION_STATUS,PO_LINE.CLOSED_CODE,po_head.SEGMENT1,po_line.LINE_NUM,
mstr.SEGMENT1 as ITEM_CODE,po_line.ITEM_DESCRIPTION,po_loc.CREATION_DATE,po_loc.PROMISED_DATE,po_loc.NEED_BY_DATE,
po_dist.QUANTITY_ORDERED,po_loc.quantity,po_loc.quantity_received,po_loc.quantity_cancelled,po_loc.quantity-po_loc.quantity_received-po_loc.quantity_cancelled outstanding,
po_line.UNIT_PRICE,po_head.CURRENCY_CODE ,mstr.ITEM_TYPE,mstr.PRIMARY_UNIT_OF_MEASURE,po_line.UNIT_MEAS_LOOKUP_CODE,cst.MATERIAL_COST,po_head.RATE,po_head.AGENT_ID
								  from APPS.MEW_C_PO_HEADERS_ALL_ID_V  po_head 
								  LEFT JOIN APPS.MEW_C_PO_LINES_ALL_ID_V  po_line on po_head.PO_HEADER_ID=po_line.PO_HEADER_ID
								  LEFT JOIN APPS.MEW_C_PO_DISTRIB_ALL_ID_V po_dist ON po_line.PO_LINE_ID=po_dist.PO_LINE_ID LEFT JOIN 
								  APPS.MEW_C_MTL_SYSTEM_ITEMS_B_ID_V mstr ON 	mstr.INVENTORY_ITEM_ID=po_line.ITEM_ID,
								  APPS.MEW_C_PO_LINE_LOC_ALL_ID_V po_loc,apps.MEW_C_AP_SUPPLIERS_ID_V vend,apps.MEW_C_AP_SUPPLIER_SITES_ID_V vdet,
                  APPS.MEW_C_CST_ITEM_COSTS_ID_V cst where 
								 mstr.INVENTORY_ITEM_ID = cst.INVENTORY_ITEM_ID 
                 AND 
                  po_head.VENDOR_SITE_ID=vdet.VENDOR_SITE_ID
								  AND
                  po_head.VENDOR_ID=vend.VENDOR_ID
                  AND
								  mstr.ORGANIZATION_ID     = cst.ORGANIZATION_ID 
								  AND cst.COST_TYPE_ID        = 1 
                  and po_head.SEGMENT1='PGM12632ID' and 
								  po_line.PO_LINE_ID=po_loc.PO_LINE_ID and mstr.ORGANIZATION_ID=222 and po_head.org_id=222  and po_head.TYPE_LOOKUP_CODE='STANDARD' 
                  AND po_loc.quantity-po_loc.quantity_received-po_loc.quantity_cancelled>0 and PO_LINE.CLOSED_CODE<>'CLOSED'
                  
                  
           