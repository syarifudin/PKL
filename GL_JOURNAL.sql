SELECT GL.JE_SOURCE, GL.JE_CATEGORY, GL.PERIOD_NAME, GL.DEFAULT_EFFECTIVE_DATE GL_DATE, GL.DOC_SEQUENCE_VALUE GL_NO, GL.NAME, GL.DESCRIPTION HEADER, GL.CURRENCY_CODE, 
									GLC.SEGMENT3 COST_CENTER, GLC.SEGMENT4 ACCOUNT_CODE, GLC.SEGMENT5 AUX, GLD.DESCRIPTION, GLD.ENTERED_DR, GLD.ENTERED_CR, GLD.ACCOUNTED_DR, GLD.ACCOUNTED_CR,
									GL.STATUS, GL.CREATED_BY, GL.DATE_CREATED, GLD.LAST_UPDATE_DATE
									,NULL as JV_NO, NULL as INVOICE_NO, NULL as BUSINESS_PARTNER
									FROM APPS.MEW_C_GL_JE_HEADERS_ID_V GL 
									LEFT JOIN APPS.MEW_C_GL_JE_LINES_ID_V GLD ON GLD.JE_HEADER_ID = GL.JE_HEADER_ID
									LEFT JOIN APPS.MEW_C_GL_CODE_COMBINATION_ID_V GLC ON GLD.CODE_COMBINATION_ID = GLC.CODE_COMBINATION_ID
									WHERE GLC.SEGMENT2 = 'B01' AND GL.JE_CATEGORY NOT IN ('Purchase Invoices','Sales Invoices') 
									and GL.DEFAULT_EFFECTIVE_DATE BETWEEN '30-May-2018' and '30-May-2018' 
									UNION ALL
									SELECT GL.JE_SOURCE, GL.JE_CATEGORY, GL.PERIOD_NAME, GL.DEFAULT_EFFECTIVE_DATE GL_DATE, GL.DOC_SEQUENCE_VALUE GL_NO, GL.NAME, GL.DESCRIPTION HEADER, GL.CURRENCY_CODE, 
									GLC.SEGMENT3 COST_CENTER, GLC.SEGMENT4 ACCOUNT_CODE, GLC.SEGMENT5 AUX, GLD.DESCRIPTION, 
									XLD.UNROUNDED_ENTERED_DR ENTERED_DR, XLD.UNROUNDED_ENTERED_CR ENTERED_CR, XLD.UNROUNDED_ACCOUNTED_DR ACCOUNTED_DR, XLD.UNROUNDED_ACCOUNTED_CR ACCOUNTED_CR, 
									GL.STATUS, GL.CREATED_BY, GL.DATE_CREATED, GLD.LAST_UPDATE_DATE
									,TO_CHAR(INV.DOC_SEQUENCE_VALUE) JV_NO, INV.INVOICE_NUM INVOICE_NO, VEND.VENDOR_NAME BUSINESS_PARTNER
									FROM APPS.MEW_C_AP_INVOICES_ALL_ID_V INV
									JOIN APPS.MEW_C_XLA_DISTRIB_LINKS_ID_V XLD ON INV.INVOICE_ID=XLD.APPLIED_TO_SOURCE_ID_NUM_1 AND INV.ORG_ID=222
									JOIN APPS.MEW_C_XLA_AE_LINES_ID_V XLL ON XLD.AE_HEADER_ID = XLL.AE_HEADER_ID AND XLD.AE_LINE_NUM = XLL.AE_LINE_NUM
									   AND XLD.ROUNDING_CLASS_CODE = 'LIABILITY'
									JOIN APPS.MEW_C_GL_JE_LINES_ID_V GLD ON GLD.GL_SL_LINK_ID = XLL.GL_SL_LINK_ID
									JOIN APPS.MEW_C_GL_JE_HEADERS_ID_V GL ON GLD.JE_HEADER_ID = GL.JE_HEADER_ID AND GL.JE_SOURCE='Payables' AND GL.JE_CATEGORY='Purchase Invoices'
									LEFT JOIN APPS.MEW_C_GL_CODE_COMBINATION_ID_V GLC ON GLD.CODE_COMBINATION_ID = GLC.CODE_COMBINATION_ID
									LEFT OUTER JOIN APPS.MEW_C_AP_SUPPLIERS_ID_V VEND ON INV.VENDOR_ID = VEND.VENDOR_ID
									WHERE GL.DEFAULT_EFFECTIVE_DATE BETWEEN  '30-May-2018' and '30-May-2018' 
									UNION ALL
									SELECT GL.JE_SOURCE, GL.JE_CATEGORY, GL.PERIOD_NAME, GL.DEFAULT_EFFECTIVE_DATE GL_DATE, GL.DOC_SEQUENCE_VALUE GL_NO, GL.NAME, GL.DESCRIPTION HEADER, GL.CURRENCY_CODE, 
									GLC.SEGMENT3 COST_CENTER, GLC.SEGMENT4 ACCOUNT_CODE, GLC.SEGMENT5 AUX, IVD.DESCRIPTION,
									XLD.UNROUNDED_ENTERED_DR ENTERED_DR, XLD.UNROUNDED_ENTERED_CR ENTERED_CR, XLD.UNROUNDED_ACCOUNTED_DR ACCOUNTED_DR, XLD.UNROUNDED_ACCOUNTED_CR ACCOUNTED_CR, 
									GL.STATUS, GL.CREATED_BY, GL.DATE_CREATED, GLD.LAST_UPDATE_DATE
									,TO_CHAR(INV.DOC_SEQUENCE_VALUE) JV_NO, INV.INVOICE_NUM INVOICE_NO, VEND.VENDOR_NAME BUSINESS_PARTNER
									FROM APPS.MEW_C_AP_INVOICES_ALL_ID_V INV  
									JOIN APPS.MEW_C_AP_INVOICE_DISTRIB_ID_V IVD ON INV.INVOICE_ID = IVD.INVOICE_ID AND INV.ORG_ID=222
									JOIN APPS.MEW_C_XLA_DISTRIB_LINKS_ID_V XLD ON IVD.INVOICE_DISTRIBUTION_ID=XLD.SOURCE_DISTRIBUTION_ID_NUM_1 AND XLD.ROUNDING_CLASS_CODE IN ('RTAX','AWT','ACCRUAL','FREIGHT','MISCELLANEOUS EXPENSE','IPV','TIPV','NRTAX','EXCHANGE_RATE_VARIANCE','ITEM EXPENSE')
									JOIN APPS.MEW_C_XLA_AE_LINES_ID_V XLL ON XLD.AE_HEADER_ID = XLL.AE_HEADER_ID AND XLD.AE_LINE_NUM = XLL.AE_LINE_NUM 
									JOIN APPS.MEW_C_GL_JE_LINES_ID_V GLD ON GLD.GL_SL_LINK_ID = XLL.GL_SL_LINK_ID
									JOIN APPS.MEW_C_GL_JE_HEADERS_ID_V GL ON GLD.JE_HEADER_ID = GL.JE_HEADER_ID AND GL.JE_SOURCE='Payables' AND GL.JE_CATEGORY='Purchase Invoices'
									LEFT JOIN APPS.MEW_C_GL_CODE_COMBINATION_ID_V GLC ON GLD.CODE_COMBINATION_ID = GLC.CODE_COMBINATION_ID
									LEFT OUTER JOIN APPS.MEW_C_AP_SUPPLIERS_ID_V VEND ON INV.VENDOR_ID = VEND.VENDOR_ID
									WHERE GL.DEFAULT_EFFECTIVE_DATE BETWEEN '30-May-2018' and '30-May-2018' 
									UNION ALL
									SELECT GL.JE_SOURCE, GL.JE_CATEGORY, GL.PERIOD_NAME, GL.DEFAULT_EFFECTIVE_DATE GL_DATE, GL.DOC_SEQUENCE_VALUE GL_NO, GL.NAME, GL.DESCRIPTION HEADER, GL.CURRENCY_CODE, 
									GLC.SEGMENT3 COST_CENTER, GLC.SEGMENT4 ACCOUNT_CODE, GLC.SEGMENT5 AUX, GLD.DESCRIPTION, 
									GLD.ENTERED_DR, GLD.ENTERED_CR, GLD.ACCOUNTED_DR, GLD.ACCOUNTED_CR,
									GL.STATUS, GL.CREATED_BY, GL.DATE_CREATED, GLD.LAST_UPDATE_DATE
									,AR.TRX_NUMBER JV_NO, AR.ATTRIBUTE10 INVOICE_NO, BILL_PARTY.PARTY_NAME BUSINESS_PARTNER
									FROM APPS.MEW_C_GL_JE_HEADERS_ID_V GL LEFT OUTER JOIN APPS.MEW_C_GL_JE_LINES_ID_V GLD ON GLD.JE_HEADER_ID = GL.JE_HEADER_ID 
									LEFT JOIN APPS.MEW_C_RA_CUST_TRX_ALL_ID_V AR ON AR.DOC_SEQUENCE_VALUE = GLD.SUBLEDGER_DOC_SEQUENCE_VALUE
									LEFT JOIN APPS.MEW_C_GL_CODE_COMBINATION_ID_V GLC ON GLD.CODE_COMBINATION_ID = GLC.CODE_COMBINATION_ID
									LEFT JOIN APPS.MEW_C_HZ_CUST_ACCOUNTS_ID_V CUST ON AR.BILL_TO_CUSTOMER_ID = CUST.CUST_ACCOUNT_ID 
									LEFT JOIN APPS.MEW_C_HZ_PARTIES_ID_V BILL_PARTY ON BILL_PARTY.PARTY_ID  = CUST.PARTY_ID
									WHERE GLC.SEGMENT2='B01' AND GL.JE_SOURCE='Receivables' AND GL.JE_CATEGORY='Sales Invoices'
									AND GL.DEFAULT_EFFECTIVE_DATE BETWEEN '30-May-2018' and '30-May-2018' 
									ORDER BY GL_NO, ACCOUNT_CODE