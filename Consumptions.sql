select t.*
      ,mgc.consumption_account           Consumption_Account
      ,mgc.consumption_aux               Consumption_AUX
from (
SELECT t.organization_Id                 organization_id
      ,t.inventory_item_Id               inventory_item_id
      ,t.period                          period
      ,t.segment1                        Company_Code
      ,t.segment2                        Account_Unit
      ,t.segment3                        Cost_Center
      ,t.segment4                        Item_Account
      ,t.segment5                        Item_AUX
      ,t.segment7                        Inv_Code
      ,t.item_Number                     Item_Number
      ,MAX(t.last_mov_ave_price)         Average_Price_start
      ,MAX(t.last_standard_price)        Standard_Price_start
      ,SUM(decode(NVL(si.attribute6,'N'),'N',last_end_qty,0))                 BeginningQty_
      ,ROUND(SUM(decode(NVL(si.attribute6,'N'),'N',last_end_bal,0)),2)        BeginningAmountSTAT
      ,SUM(seg1_qty)                     Purchasing_Qty  
      ,SUM(round(seg1_amt,2))            PurchasingAmount
      ,SUM(seg3_qty)                     Incoming_Qty  
      ,SUM(round(seg3_amt,2))            Incoming_Amount  
      ,SUM(seg8_qty)                     Outgoing_Qty_  
      ,SUM(round(seg8_amt,2))            Outgoing_Amount  
      ,MAX(t.cur_mov_ave_price)          AveragePriceend
      ,MAX(t.cur_standard_price)         StandardPriceend
      ,SUM(decode(NVL(si.attribute6,'N'),'N',end_qty,0))             Ending_Qty
      ,ROUND(SUM(decode(NVL(si.attribute6,'N'),'N',end_bal,0)),2)             EndingAmountSTAT
      ,(
           SUM(decode(NVL(si.attribute6,'N'),'N',last_end_qty,0))
         + SUM(seg1_qty)
         + SUM(seg2_qty)
         + SUM(seg3_qty)
         + SUM(seg4_qty)
         + SUM(seg5_qty)
         + SUM(seg6_qty)
         + SUM(seg7_qty)
         + SUM(seg8_qty)
--         + SUM(seg9_qty)
--         - SUM(end_qty)
         - ROUND(SUM(decode(NVL(si.attribute6,'N'),'N',end_qty,0)),2)
       )                                 ConsumptionQty
      ,(
           ROUND(SUM(decode(NVL(si.attribute6,'N'),'N',last_end_bal,0)),2)
         + SUM(round(seg1_amt,2))
         + SUM(round(seg2_amt,2))
         + SUM(round(seg3_amt,2))
         + SUM(round(seg4_amt,2))
         + SUM(round(seg5_amt,2))
         + SUM(round(seg6_amt,2))
         + SUM(round(seg7_amt,2))
         + SUM(round(seg8_amt,2))
         - ROUND(SUM(decode(NVL(si.attribute6,'N'),'N',end_bal,0)),2)
       )                                 ConsumptionAmount
      ,od.organization_name legal_entity
      ,o.organization_code organization_code
FROM 
(
SELECT organization_id
      ,period
      ,subinventory_code
      ,inventory_item_id
      ,item_number
      ,segment1
      ,segment2
      ,segment3
      ,segment4
      ,segment5
      ,segment7  
      ,last_end_bal
      ,seg1_amt
      ,seg2_amt
      ,seg3_amt
      ,seg4_amt
      ,seg5_amt
      ,seg6_amt
      ,seg7_amt
      ,seg8_amt
      ,seg9_amt
      ,end_bal
      ,last_end_qty
      ,seg1_qty
      ,seg2_qty
      ,seg3_qty
      ,seg4_qty
      ,seg5_qty
      ,seg6_qty
      ,seg7_qty
      ,seg8_qty
      ,seg9_qty
      ,end_qty
      ,cur_mov_ave_price
      ,cur_standard_price
      ,last_mov_ave_price
      ,last_standard_price
      ,journal_flag
FROM
(
        SELECT base.organization_id
              ,base.gl_period                                  period
              ,base.subinventory_code
              ,base.inventory_item_id
              ,base.item_number
              ,gcc.segment1
              ,gcc.segment2
              ,base.segment3
              ,base.segment4
              ,base.segment5
              ,base.segment7   
              ,SUM(NVL(lstq.mn_end_inv_quantity,0) * NVL(lmiv.cur_mov_ave_price,0))     last_end_bal
              ,0 seg1_amt
              ,0 seg2_amt
              ,0 seg3_amt
              ,0 seg4_amt
              ,0 seg5_amt
              ,0 seg6_amt
              ,0 seg7_amt
              ,0 seg8_amt
              ,0 seg9_amt

              ,SUM(NVL(tstq.mn_end_inv_quantity,0) * NVL(tstq.actual_price,0))     end_bal    
              ,SUM(NVL(lstq.mn_end_inv_quantity,0))         last_end_qty
              ,0 seg1_qty
              ,0 seg2_qty
              ,0 seg3_qty
              ,0 seg4_qty
              ,0 seg5_qty
              ,0 seg6_qty
              ,0 seg7_qty
              ,0 seg8_qty
              ,0 seg9_qty

              ,SUM(NVL(tstq.mn_end_inv_quantity,0))   end_qty
              ,NVL(lmiv.cur_mov_ave_price,0)          last_mov_ave_price
              ,NVL(lmiv.standard_price,0)             last_standard_price
              ,NVL(tmiv.cur_mov_ave_price,0)          cur_mov_ave_price
              ,NVL(tmiv.standard_price,0)             cur_standard_price
              ,'0'                                    journal_flag
        FROM
              (SELECT DISTINCT
                      organization_id
                     ,gl_period
                     ,segment3
                     ,subinventory_code
                     ,item_number
                     ,segment4
                     ,segment7 
                     ,segment5
                     ,inventory_item_id
               FROM  (SELECT DISTINCT
                             organization_id
                            ,gl_period
                            ,segment3
                            ,subinventory_code
                            ,item_number
                            ,segment4
                            ,segment5
                            ,segment7
                            ,inventory_item_id
                      FROM   apps.MEW_INV_ACCOUNT_TBL_ID_V 
                      WHERE  NVL(primary_quantity,0)       != 0
                      OR     NVL(base_transaction_value,0) != 0
                      UNION
                      SELECT DISTINCT
                             organization_id
                            ,appli_yr_mn
                            ,department_code
                            ,subinventory_code
                            ,item_number
                            ,account
                            ,aux
                            ,inventory_code 
                            ,inventory_item_id
                      FROM   apps.MEW_IV_STKQTY_ID_V 
                      WHERE  NVL(mn_end_inv_quantity,0) != 0
                      UNION
                      SELECT DISTINCT
                             organization_id
                            ,TO_CHAR(ADD_MONTHS(TO_DATE('01-'||appli_yr_mn,'DD-Mon-RR'),1),'Mon-RR')
                            ,department_code
                            ,subinventory_code
                            ,item_number
                            ,account
                            ,aux
                            ,inventory_code 
                            ,inventory_item_id
                      FROM   apps.MEW_IV_STKQTY_ID_V 
                      WHERE  NVL(mn_end_inv_quantity,0)!=0
                      )
               )                       base
              ,apps.MEW_IV_STKQTY_ID_V          tstq
              ,apps.MEW_IV_STKQTY_ID_V          lstq
              ,apps.MEW_IV_MOVAVEPRICE_ID_V     tmiv
              ,apps.MEW_IV_MOVAVEPRICE_ID_V     lmiv
              ,apps.MEW_C_MTL_PARAMETERS_ID_V    mp
              ,apps.MEW_C_GL_CODE_COMBINATION_ID_V   gcc
        WHERE  base.organization_id    = tstq.organization_id    (+)
        AND    base.segment3           = tstq.department_code    (+)
        AND    base.subinventory_code  = tstq.subinventory_code  (+)
        AND    base.item_number        = tstq.item_number        (+)
        AND    base.segment4           = tstq.account            (+)
        AND    base.segment5           = tstq.aux                (+)
        AND    base.segment7           = tstq.inventory_code     (+) 
        AND    base.gl_period          = tstq.appli_yr_mn        (+)
        AND    base.organization_id    = lstq.organization_id    (+)
        AND    base.segment3           = lstq.department_code    (+)
        AND    base.subinventory_code  = lstq.subinventory_code  (+)
        AND    base.item_number        = lstq.item_number        (+)
        AND    base.segment4           = lstq.account            (+)
        AND    base.segment5           = lstq.aux                (+)
        AND    base.segment7           = lstq.inventory_code     (+)  
        AND    to_char(ADD_MONTHS(TO_DATE('01-'||base.gl_period ,'DD-Mon-RR'),-1),'Mon-RR') = lstq.appli_yr_mn(+)
        AND    base.organization_id       = tmiv.organization_id
        AND    base.gl_period             = tmiv.appli_yr_mn
        AND    base.inventory_item_id     = tmiv.inventory_item_id
        AND    lstq.organization_id+0     = lmiv.organization_id  (+)
        AND    lstq.appli_yr_mn           = lmiv.appli_yr_mn      (+)
        AND    lstq.inventory_item_id+0   = lmiv.inventory_item_id(+)
        AND    mp.organization_id         = base.organization_id
        AND    gcc.code_combination_id    = mp.material_account
        GROUP BY
               base.organization_id
              ,base.gl_period
              ,base.subinventory_code
              ,base.inventory_item_id
              ,base.item_number
              ,gcc.segment1
              ,gcc.segment2
              ,base.segment3
              ,base.segment4
              ,base.segment5
              ,base.segment7   
              ,lmiv.cur_mov_ave_price
              ,lmiv.standard_price
              ,tmiv.cur_mov_ave_price
              ,tmiv.standard_price
    )
    UNION ALL
    (
SELECT NVL(miat.organization_id,decode(miat.segment1 || miat.segment2,'26B01',182,'26C11',222,0))    organization_id
              ,miat.gl_period                                              period
              ,miat.subinventory_code                                      subinventory_code
              ,NVL(miat.inventory_item_id,0)                                      inventory_item_id
              ,NVL(miat.item_number,'Manual')                                 item_number
              ,miat.segment1                                               segment1
              ,miat.segment2                                               segment2
              ,miat.segment3                                               segment3
              ,miat.segment4                                               segment4
              ,miat.segment5                                               segment5
              ,miat.segment7                                               segment7 
              ,0 last_end_bal
              ,SUM(DECODE(miat.segment8,'1',miat.base_transaction_value,0))   seg1_amt
              ,SUM(DECODE(miat.segment8,'2',miat.base_transaction_value,0))   seg2_amt
              ,SUM(DECODE(miat.segment8,'3',miat.base_transaction_value,0))   seg3_amt
              ,SUM(DECODE(miat.segment8,'4',miat.base_transaction_value,0))   seg4_amt
              ,SUM(DECODE(miat.segment8,'5',miat.base_transaction_value,0))   seg5_amt
              ,SUM(DECODE(miat.segment8,'6',miat.base_transaction_value,0))   seg6_amt
              ,SUM(DECODE(miat.segment8,'7',miat.base_transaction_value,0))   seg7_amt
              ,SUM(DECODE(miat.segment8,'8',miat.base_transaction_value,0))   seg8_amt
              ,SUM(DECODE(miat.segment8,'9',miat.base_transaction_value,0))   seg9_amt
              ,0 end_bal
              ,0 last_end_qty
              ,SUM(DECODE(msi.item_type,'OP',0,DECODE(miat.segment8,'1',miat.primary_quantity,0)))         seg1_qty
              ,SUM(DECODE(msi.item_type,'OP',0,DECODE(miat.segment8,'2',miat.primary_quantity,0)))         seg2_qty
              ,SUM(DECODE(msi.item_type,'OP',0,DECODE(miat.segment8,'3',miat.primary_quantity,0)))         seg3_qty
              ,SUM(DECODE(msi.item_type,'OP',0,DECODE(miat.segment8,'4',miat.primary_quantity,0)))         seg4_qty
              ,SUM(DECODE(msi.item_type,'OP',0,DECODE(miat.segment8,'5',miat.primary_quantity,0)))         seg5_qty
              ,SUM(DECODE(msi.item_type,'OP',0,DECODE(miat.segment8,'6',miat.primary_quantity,0)))         seg6_qty
              ,SUM(DECODE(msi.item_type,'OP',0,DECODE(miat.segment8,'7',miat.primary_quantity,0)))         seg7_qty
              ,SUM(DECODE(msi.item_type,'OP',0,DECODE(miat.segment8,'8',miat.primary_quantity,0)))         seg8_qty
              ,SUM(DECODE(msi.item_type,'OP',0,DECODE(miat.segment8,'9',miat.primary_quantity,0)))         seg9_qty
              ,0 end_qty
              ,0 cur_mov_ave_price
              ,0 cur_standard_price
              ,0 last_mov_ave_price
              ,0 last_standard_price
              ,NVL(miat.attribute3,'1') journal_flag
        FROM   apps.MEW_C_MTL_SYSTEM_ITEMS_B_ID_V  msi 
              ,apps.MEW_INV_ACCOUNT_TBL_ID_V miat 
        WHERE  msi.inventory_item_id(+)=miat.inventory_item_id
        AND    msi.organization_id(+)  =miat.organization_id
        AND    ( miat.attribute3 = '1' or ( miat.attribute3 = '3' and miat.attribute2 in ( 'C','G') )) 
        GROUP BY
               NVL(miat.organization_id,decode(miat.segment1 || miat.segment2,'26B01',182,'26C11',222,0))
              ,miat.gl_period
              ,miat.subinventory_code
              ,NVL(miat.inventory_item_id,0)
              ,NVL(miat.item_number,'Manual')
              ,miat.segment1
              ,miat.segment2
              ,miat.segment3
              ,miat.segment4
              ,miat.segment5
              ,miat.segment7
              ,NVL(miat.attribute3,'1')
    )
     )    t
      ,apps.MEW_C_MTL_PARAMETERS_ID_V     o 
      ,apps.MEW_C_MTL_PARAMETERS_ID_V     m 
      ,apps.MEW_C_ORG_DEFINITIONS_ID_V    od 
      ,apps.MEW_C_MTL_SEC_INVENTORIES_ID_V   si 
WHERE    o.organization_id   = t.organization_id
AND    m.organization_id   = o.master_organization_id
AND    od.organization_id  = m.organization_id
AND    t.organization_id = si.organization_id (+)  
AND    t.subinventory_code = si.secondary_inventory_name (+)
and   t.organization_id = 222                 
and   t.period = 'Aug-17'                     
GROUP BY
       t.organization_Id
      ,t.inventory_item_Id
      ,t.period
      ,t.segment1
      ,t.segment2
      ,t.segment3
      ,t.segment4
      ,t.segment5
      ,t.segment7 
      ,t.item_Number
      ,od.organization_name
      ,o.organization_code
) t
,apps.MEW_GL_CONSUMPTION_ID_V           mgc 
where  t.Item_Account = mgc.inventory_account(+)
AND    t.Item_AUX = mgc.inventory_aux(+)
AND    mgc.set_of_books_id(+)      = 2061
