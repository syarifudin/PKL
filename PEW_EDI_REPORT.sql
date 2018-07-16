select to_char(SO_HEAD.CREATION_DATE,'YYYY-MM-DD') PO_DATE,SO.ORDER_NUMBER,SUBSTR(SO_HEAD.PO_NUMBER,1,5) PO_NUMBER,SO_HEAD.ORDERER_CODE,SO_HEAD.CUST_PO_NUMBER,
SO_LINE.HEADER_ID,SO_LINE.LINE_NUMBER,SO_LINE.INVENTORY_ITEM_ID,SO_LINE.SCHEDULE_DATE,
SO_LINE.QUANTITY,SO_HEAD.CURRENCY,SO_LINE.PRICE,SO_LINE.PART_NUMBER,SO_LINE.SEQUENCE_NUMBER,SO_LINE.ORIGINAL_SEQ_NO,SO_LINE.ERROR_CODE,
SO_LINE.BRAND_CODE,SO_LINE.DATA_ID,SO_LINE.IMPORT_FLAG,SO_LINE.ERROR_MESSAGE
from APPS.MEW_SO_EDI_ANS_HEADERS_ID_V SO_HEAD LEFT JOIN APPS.MEW_SO_EDI_ANS_LINES_ID_V  SO_LINE ON SO_HEAD.HEADER_ID=SO_LINE.HEADER_ID LEFT JOIN APPS.MEW_C_OE_ORDER_HEADERS_ID_V SO ON 
SO_HEAD.SO_HEADER_ID=SO.HEADER_ID
where  SO_HEAD.ORGANIZATION_ID=222 and SO_LINE.ORGANIZATION_ID=222 and   SO_LINE.DATA_ID='J2A' --SUBSTR(SO_HEAD.PO_NUMBER,1,5)=74530 


select * from APPS.MEW_SO_EDI_ANS_LINES_ID_V  where data_id='J2A'


and SO_LINE.PART_NUMBER='NNP84930031'
select * from APPS.MEW_SO_EDI_ANS_LINES_ID_V where ORGANIZATION_ID='222' 
select a.PO_NUMBER,b.LINE_NUMBER,b.PART_NUMBER,b.QUANTITY,b.PRICE,b.SEQUENCE_NUMBER,b.ORIGINAL_SEQ_NO,b.DATA_ID from  
APPS.MEW_SO_EDI_ANS_HEADERS_ID_V a,APPS.MEW_SO_EDI_ANS_LINES_ID_V b where a.HEADER_ID=b.HEADER_ID and a.ORGANIZATION_ID='222' and a.PO_NUMBER='73564-006119'
select * from  APPS.MEW_SO_EDI_ANS_LINES_ID_V  
select * from apps.MTL_SYSTEM_ITEMS_B