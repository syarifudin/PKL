SELECT om_line.line_ID,AR_.CREATION_DATE,om_line.LINE_NUMBER,
							  dlv_det.SOURCE_LINE_NUMBER AS LINE_SPLIT,
							  om_line.ORDERED_ITEM,
							  to_char(om_line.PROMISE_DATE,'dd-mm-YYYY')   PROMISE_DATE,
							  to_char(om_line.SCHEDULE_SHIP_DATE,'dd-mm-YYYY') SCHEDULE_SHIP_DATE,
							  om_header.TRANSACTIONAL_CURR_CODE,
                case
                WHEN (dlv_det.REQUESTED_QUANTITY IS NULL AND om_line.FLOW_STATUS_CODE !='AWAITING_RETURN')
                then om_line.ORDERED_QUANTITY
                else dlv_det.REQUESTED_QUANTITY
                END AS ORDERED_QUANTITY,
          		  dlv_det.SHIPPED_QUANTITY AS SHIPPED_QUANTITY,
							  om_line.CANCELLED_QUANTITY,
                om_line.SPLIT_BY,	
							  om_line.UNIT_SELLING_PRICE,
							  CASE
								WHEN (om_header.ORDER_NUMBER LIKE '%6000%'
								OR om_header.ORDER_NUMBER LIKE '%6400%')
								THEN om_line.UNIT_SELLING_PRICE * TO_BINARY_FLOAT (om_line.INVOICED_QUANTITY)
								WHEN om_line.FLOW_STATUS_CODE = 'AWAITING_SHIPPING'
								THEN om_line.UNIT_SELLING_PRICE * TO_BINARY_FLOAT (om_line.ORDERED_QUANTITY)
								ELSE om_line.UNIT_SELLING_PRICE * TO_BINARY_FLOAT (dlv_det.SHIPPED_QUANTITY)
							  END AS Amount,
							  om_line.SHIPPING_QUANTITY_UOM,
							  to_char(om_header.ORDERED_DATE,'dd-mm-YYYY') ORDERED_DATE,
							  to_char(om_line.REQUEST_DATE,'dd-mm-YYYY')REQUEST_DATE,
							  to_char(om_line.ACTUAL_SHIPMENT_DATE,'dd-mm-YYYY')ACTUAL_SHIPMENT_DATE,
							  mstr_del.DELIVERY_ID,
							  mstr_del.ATTRIBUTE7 AS Surat_Jalan,
							  AR_.ATTRIBUTE10,
                mstr_del.ATTRIBUTE4  ON_OR_ABOUT,
							  om_header.ORDER_NUMBER,
							  om_header.CUST_PO_NUMBER,
							  to_char(om_line.FULFILLMENT_DATE,'dd-mm-YYYY') FULFILLMENT_DATE,
							  om_line.FULFILLED_QUANTITY,
							  om_line.INVOICE_INTERFACE_STATUS_CODE,
                  CASE 
                      WHEN  (om_header.ORDER_NUMBER LIKE '%6000%' OR om_header.ORDER_NUMBER LIKE '%6400%')
                           THEN om_line.INVOICED_QUANTITY
                           else dlv_det.SHIPPED_QUANTITY
                           end as INVOICED_QUANTITY,
							  om_line.ACCEPTED_QUANTITY AS POSTED_QTY,
							  om_line.FLOW_STATUS_CODE  AS Status,
							 CASE
								WHEN AR.CT_REFERENCE IS NOT NULL
								THEN 'YES'
								ELSE 'NOT YET'
							  END AS STATUS_AR,
							  om_line.TAX_CODE,
							  b.PARTY_NAME,
							  f.PARTY_SITE_NAME,
							  g.ADDRESS1,
							  g.ADDRESS2,
							  g.ADDRESS3,
							  g.ADDRESS4,
							  g.CITY,
							  h.PACKING_STYLE_CODE,
							  h.QUANTITY_PER_PACKING,
							  h.NET_WEIGHT,
							  h.GROSS_WEIGHT,
							  h.WIDTH,
							  h.DEPTH,
							  h.HEIGHT,
							  (h.WIDTH                 * h.DEPTH * h.HEIGHT)    AS M3,
							  dlv_det.SHIPPED_QUANTITY / h.QUANTITY_PER_PACKING AS Total_Pack,
							  mstr_del.TP_ATTRIBUTE1,
							  mstr_del.TP_ATTRIBUTE2,
                case 
                  when om_line.ORDER_SOURCE_ID=1021
                  THEN     'PEW EDI'
                  END SOURCE_DATA,
                  AR_.ATTRIBUTE12
							FROM APPS.MEW_C_HZ_LOCATIONS_ID_V g,
							  APPS.MEW_C_HZ_PARTY_SITES_ID_V f,
							  APPS.MEW_C_HZ_CUST_SITE_USES_ID_V d,
							  APPS.MEW_C_HZ_CUST_ACCT_SITES_ID_V e,
							  APPS.MEW_C_HZ_CUST_ACCOUNTS_ID_V a,
							  APPS.MEW_C_HZ_PARTIES_ID_V b,
							  APPS.MEW_C_OE_ORDER_LINES_ALL_ID_V om_line 
							LEFT OUTER JOIN APPS.MEW_C_OE_ORDER_HEADERS_ID_V om_header
							ON om_header.HEADER_ID = om_line.HEADER_ID
							LEFT OUTER JOIN APPS.MEW_C_WSH_DELIV_DETAILS_ID_V dlv_det
							ON om_line.LINE_ID = dlv_det.SOURCE_LINE_ID
							LEFT OUTER JOIN APPS.MEW_C_WSH_DELIV_ASSIGN_ID_V del_ass
							ON del_ass.DELIVERY_DETAIL_ID = dlv_det.DELIVERY_DETAIL_ID
							LEFT OUTER JOIN APPS.MEW_C_WSH_NEW_DELIVERIES_ID_V mstr_del
							ON mstr_del.DELIVERY_ID = del_ass.DELIVERY_ID left JOIN (select a.ATTRIBUTE10,b.INTERFACE_LINE_ATTRIBUTE6,a.ATTRIBUTE12,b.CREATION_DATE from APPS.MEW_C_RA_CUST_TRX_ALL_ID_V a,APPS.MEW_C_RA_CUST_TRX_LINES_ID_V b where a.CUSTOMER_TRX_ID=b.CUSTOMER_TRX_ID) AR_ 
              ON om_line.line_ID=AR_.INTERFACE_LINE_ATTRIBUTE6
							LEFT OUTER JOIN
							  (SELECT INVENTORY_ITEM_ID,    PACKING_STYLE_CODE,    QUANTITY_PER_PACKING,    NET_WEIGHT,    GROSS_WEIGHT,    WIDTH,    DEPTH,    HEIGHT  FROM APPS.MEW_GEDI_ID_PACKING_ID_V  WHERE PACKING_STYLE_CODE = 'CB'  AND ORGANIZATION_ID= 222
							  ) h
							ON om_line.INVENTORY_ITEM_ID = h.INVENTORY_ITEM_ID
							LEFT  JOIN (select distinct(CT_REFERENCE)  from APPS.MEW_C_RA_CUST_TRX_ALL_ID_V) AR
							ON AR.CT_REFERENCE                 = TO_CHAR(mstr_del.DELIVERY_ID) 
							WHERE a.PARTY_ID                   = b.PARTY_ID
							AND a.CUST_ACCOUNT_ID              = om_header.SOLD_TO_ORG_ID
							AND om_header.SHIP_TO_ORG_ID       = d.site_USE_ID
							AND d.CUST_ACCT_SITE_ID            = e.CUST_ACCT_SITE_ID
							AND e.PARTY_SITE_ID                = f.PARTY_SITE_ID
							AND f.LOCATION_ID                  = g.LOCATION_ID 
             AND (to_char(om_line.ACTUAL_SHIPMENT_DATE,'mm-YYYY')>='11-2017' --to_char(sysdate, 'mm-YYYY') -- OR to_char(AR_.CREATION_DATE,'mm-YYYY')=to_char(sysdate, 'mm-YYYY')
             OR om_line.ACTUAL_SHIPMENT_DATE   IS  NULL)--AND om_line.FLOW_STATUS_CODE !='CANCELLED') 
						 AND om_line.ORG_ID                 = 222 	ORDER BY om_line.INVOICE_INTERFACE_STATUS_CODE,om_header.ORDER_NUMBER
SELECT om_line.LINE_NUMBER,
							  dlv_det.SOURCE_LINE_NUMBER AS LINE_SPLIT,
							  om_line.ORDERED_ITEM,
							  om_line.PROMISE_DATE AS PROMISE_DATE,
							  om_line.SCHEDULE_SHIP_DATE,
							  om_header.TRANSACTIONAL_CURR_CODE,
							  case
                WHEN (dlv_det.REQUESTED_QUANTITY IS NULL AND om_line.FLOW_STATUS_CODE !='AWAITING_RETURN')
                then om_line.ORDERED_QUANTITY
                else dlv_det.REQUESTED_QUANTITY
                END AS ORDERED_QUANTITY,
							  dlv_det.SHIPPED_QUANTITY AS SHIPPED_QUANTITY,
							  om_line.CANCELLED_QUANTITY,
                om_line.SPLIT_BY,	
							  om_line.UNIT_SELLING_PRICE,
							  CASE
								WHEN (om_header.ORDER_NUMBER LIKE '%6000%'
								OR om_header.ORDER_NUMBER LIKE '%6400%')
								THEN om_line.UNIT_SELLING_PRICE * om_line.INVOICED_QUANTITY
								WHEN om_line.FLOW_STATUS_CODE = 'AWAITING_SHIPPING'
								THEN om_line.UNIT_SELLING_PRICE * om_line.ORDERED_QUANTITY
								ELSE om_line.UNIT_SELLING_PRICE * dlv_det.SHIPPED_QUANTITY
							  END AS Amount,
							  om_line.SHIPPING_QUANTITY_UOM,
							  om_header.ORDERED_DATE,
							  om_header.REQUEST_DATE,
							  om_line.ACTUAL_SHIPMENT_DATE,
							  mstr_del.DELIVERY_ID,
							  mstr_del.ATTRIBUTE7 AS Surat_Jalan,
							  AR_.ATTRIBUTE10,
							  mstr_del.ATTRIBUTE4 AS ON_OR_ABOUT,
							  om_header.ORDER_NUMBER,
							  om_header.CUST_PO_NUMBER,
							  om_line.FULFILLMENT_DATE,
							  om_line.FULFILLED_QUANTITY,
							  om_line.INVOICE_INTERFACE_STATUS_CODE,
                  CASE 
                      WHEN  (om_header.ORDER_NUMBER LIKE '%6000%' OR om_header.ORDER_NUMBER LIKE '%6400%')
                           THEN om_line.INVOICED_QUANTITY
                           else dlv_det.SHIPPED_QUANTITY
                           end as INVOICED_QUANTITY,
							  om_line.ACCEPTED_QUANTITY AS POSTED_QTY,
							  om_line.FLOW_STATUS_CODE  AS Status,
							 CASE
								WHEN AR.CT_REFERENCE IS NOT NULL
								THEN 'YES'
								ELSE 'NOT YET'
							  END AS STATUS_AR,
							  om_line.TAX_CODE,
							  b.PARTY_NAME,
							  f.PARTY_SITE_NAME,
							  g.ADDRESS1,
							  g.ADDRESS2,
							  g.ADDRESS3,
							  g.ADDRESS4,
							  g.CITY,
							  h.PACKING_STYLE_CODE,
							  h.QUANTITY_PER_PACKING,
							  h.NET_WEIGHT,
							  h.GROSS_WEIGHT,
							  h.WIDTH,
							  h.DEPTH,
							  h.HEIGHT,
							  (h.WIDTH * h.DEPTH * h.HEIGHT)    AS M3,
							  dlv_det.SHIPPED_QUANTITY / h.QUANTITY_PER_PACKING AS Total_Pack,
							  mstr_del.TP_ATTRIBUTE1,
							  mstr_del.TP_ATTRIBUTE2
							FROM APPS.MEW_C_HZ_LOCATIONS_ID_V g,
							  APPS.MEW_C_HZ_PARTY_SITES_ID_V f,
							  APPS.MEW_C_HZ_CUST_SITE_USES_ID_V d,
							  APPS.MEW_C_HZ_CUST_ACCT_SITES_ID_V e,
							  APPS.MEW_C_HZ_CUST_ACCOUNTS_ID_V a,
							  APPS.MEW_C_HZ_PARTIES_ID_V b,
							  APPS.MEW_C_OE_ORDER_LINES_ALL_ID_V om_line 
							LEFT OUTER JOIN APPS.MEW_C_OE_ORDER_HEADERS_ID_V om_header
							ON om_header.HEADER_ID = om_line.HEADER_ID
							LEFT OUTER JOIN APPS.MEW_C_WSH_DELIV_DETAILS_ID_V dlv_det
							ON om_line.LINE_ID = dlv_det.SOURCE_LINE_ID
							LEFT OUTER JOIN APPS.MEW_C_WSH_DELIV_ASSIGN_ID_V del_ass
							ON del_ass.DELIVERY_DETAIL_ID = dlv_det.DELIVERY_DETAIL_ID
							LEFT OUTER JOIN APPS.MEW_C_WSH_NEW_DELIVERIES_ID_V mstr_del
							ON mstr_del.DELIVERY_ID = del_ass.DELIVERY_ID left JOIN (select a.ATTRIBUTE10,b.INTERFACE_LINE_ATTRIBUTE6 from APPS.MEW_C_RA_CUST_TRX_ALL_ID_V a,APPS.MEW_C_RA_CUST_TRX_LINES_ID_V b where a.CUSTOMER_TRX_ID=b.CUSTOMER_TRX_ID) AR_ ON om_line.line_ID=AR_.INTERFACE_LINE_ATTRIBUTE6
							LEFT OUTER JOIN
							  (SELECT INVENTORY_ITEM_ID,    PACKING_STYLE_CODE,    QUANTITY_PER_PACKING,    NET_WEIGHT,    GROSS_WEIGHT,    WIDTH,    DEPTH,    HEIGHT  FROM APPS.MEW_GEDI_ID_PACKING_ID_V  WHERE PACKING_STYLE_CODE = 'CB'  AND ORGANIZATION_ID      = '222'
							  ) h
							ON om_line.INVENTORY_ITEM_ID = h.INVENTORY_ITEM_ID
							LEFT  JOIN (select distinct(CT_REFERENCE)  from APPS.MEW_C_RA_CUST_TRX_ALL_ID_V) AR
							ON AR.CT_REFERENCE                 = TO_CHAR(mstr_del.DELIVERY_ID)
							WHERE a.PARTY_ID                   = b.PARTY_ID
							AND a.CUST_ACCOUNT_ID              = om_header.SOLD_TO_ORG_ID
							AND om_header.SHIP_TO_ORG_ID       = d.site_USE_ID
							AND d.CUST_ACCT_SITE_ID            = e.CUST_ACCT_SITE_ID
							AND e.PARTY_SITE_ID                = f.PARTY_SITE_ID
							AND f.LOCATION_ID                  = g.LOCATION_ID
							AND (om_line.ACTUAL_SHIPMENT_DATE >= '01-Oct-17'  and om_line.FLOW_STATUS_CODE !='CANCELLED') and
							ORDER BY om_line.INVOICE_INTERFACE_STATUS_CODE,om_header.ORDER_NUMBER