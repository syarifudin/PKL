select AR.TRX_NUMBER AR_NNUMBER,
									AR.ATTRIBUTE10 INVOICE_NNUMBER, 
									BILL_PARTY.PARTY_NAME BILL_TO,
									CUST.ACCOUNT_NUMBER,
									BILL_PARTY.ADDRESS1,
									--BILL_PARTY.ADDRESS2,
								--	BILL_PARTY.ADDRESS3,
									--BILL_PARTY.ADDRESS4,
                  LOC.ADDRESS1 SHIP_TO_SITE,
									case when NDLV.ATTRIBUTE4 is null then TO_CHAR(TO_DATE(AR.CREATION_DATE,'DD-MON-YY'),'MM/DD/YYYY')
											else
                  TO_CHAR(SUBSTR(NDLV.ATTRIBUTE4,6,2)||'/'||SUBSTR(NDLV.ATTRIBUTE4,9,2)||'/'||SUBSTR(NDLV.ATTRIBUTE4,1,4)) end as INVOICE_DATE,
									PAY.DUE_DATE,
									AR.INVOICE_CURRENCY_CODE CURRENCY,
									(CASE WHEN((SYSDATE) - TRUNC(PAY.DUE_DATE) <= 30) THEN NVL(PAY.AMOUNT_DUE_REMAINING,0)
									ELSE 0 END ) AMOUNT_REMAINING,
									(CASE WHEN((SYSDATE) - TRUNC(PAY.DUE_DATE) BETWEEN 31 AND 60) THEN NVL(PAY.AMOUNT_DUE_REMAINING,0)
									ELSE 0 END ) OVERDUE_30,
									(CASE WHEN((SYSDATE) - TRUNC(PAY.DUE_DATE) BETWEEN 61 AND 90) THEN NVL(PAY.AMOUNT_DUE_REMAINING,0)
									ELSE 0 END ) OVERDUE_60,
									(CASE WHEN((SYSDATE) - TRUNC(PAY.DUE_DATE) >90) THEN NVL(PAY.AMOUNT_DUE_REMAINING,0)
									ELSE 0 END ) OVERDUE_90
									from APPS.MEW_C_RA_CUST_TRX_ALL_ID_V AR
									LEFT JOIN APPS.MEW_C_HZ_CUST_ACCOUNTS_ID_V CUST ON AR.BILL_TO_CUSTOMER_ID = CUST.CUST_ACCOUNT_ID 
									LEFT JOIN APPS.MEW_C_HZ_PARTIES_ID_V BILL_PARTY ON BILL_PARTY.PARTY_ID  = CUST.PARTY_ID
                           left outer join APPS.MEW_C_HZ_CUST_SITE_USES_ID_V SITE on AR.SHIP_TO_SITE_USE_ID = SITE.SITE_USE_ID
                        left outer join APPS.MEW_C_HZ_CUST_ACCT_SITES_ID_V CUST_ACCT on SITE.CUST_ACCT_SITE_ID = CUST_ACCT.CUST_ACCT_SITE_ID
                          left outer join APPS.MEW_C_HZ_PARTY_SITES_ID_V P_SITE on CUST_ACCT.PARTY_SITE_ID = P_SITE.PARTY_SITE_ID
                           left outer join APPS.MEW_C_HZ_LOCATIONS_ID_V LOC on P_SITE.LOCATION_ID = LOC.LOCATION_ID
									LEFT JOIN apps.MEW_C_AR_PAYMENT_SCHE_ID_V PAY ON AR.TRX_NUMBER = PAY.TRX_NUMBER
									LEFT JOIN APPS.MEW_C_WSH_NEW_DELIVERIES_ID_V NDLV ON AR.CT_REFERENCE = TO_CHAR(NDLV.DELIVERY_ID)
									WHERE AR.ATTRIBUTE_CATEGORY IN ('182') AND PAY.AMOUNT_DUE_REMAINING <> 0 and BILL_PARTY.PARTY_NAME like '26-PES PC' and (to_char(AR.TRX_DATE,'mm-YYYY')!=to_char(sysdate, 'mm-YYYY')) 
									order by AR.INVOICE_CURRENCY_CODE
                  