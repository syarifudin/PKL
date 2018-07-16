 select    to_char(om_header.ORDERED_DATE,'dd-mm-YYYY') Order_Date,
              SUM(om_line.UNIT_SELLING_PRICE * TO_BINARY_FLOAT (om_line.ORDERED_QUANTITY)) AS AMOUNT
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
							WHERE a.PARTY_ID                   = b.PARTY_ID
						AND a.CUST_ACCOUNT_ID              = om_header.SOLD_TO_ORG_ID
							AND om_header.SHIP_TO_ORG_ID       = d.site_USE_ID
							AND d.CUST_ACCT_SITE_ID            = e.CUST_ACCT_SITE_ID
							AND e.PARTY_SITE_ID                = f.PARTY_SITE_ID
							AND f.LOCATION_ID                  = g.LOCATION_ID AND PARTY_NAME='26-PESGSID'
             AND (to_char(om_header.ORDERED_DATE,'mm-YYYY')=to_char(sysdate, 'mm-YYYY')) 
						 AND om_line.ORG_ID = 222 GROUP BY to_char(om_header.ORDERED_DATE,'dd-mm-YYYY') order by 1
             
             