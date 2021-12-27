FUNCTION ZKK_ADD_PRODUCT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PRODUCTID) TYPE  ZKK_PRODUCTID
*"     REFERENCE(IV_PRODUCTNAME) TYPE  ZKK_PRODUCT_NAME
*"     REFERENCE(IV_SUPPLIERDID) TYPE  ZKK_SUPPLIERID
*"     REFERENCE(IV_CATEGORYID) TYPE  ZKK_CATEGORYID
*"     REFERENCE(IV_QUANTITYPERUNIT) TYPE  ZKK_QUANTITY_PER_UNIT
*"     REFERENCE(IV_UNITPRICE) TYPE  ZKK_UNITPRICE
*"     REFERENCE(IV_UNITONORDER) TYPE  ZKK_UNIT_ON_ORDER
*"     REFERENCE(IV_REORDERLEVEL) TYPE  ZKK_REORDER_LEVEL
*"     REFERENCE(IV_DISCONTINUED) TYPE  ZKK_DISCONTINUED
*"  EXPORTING
*"     REFERENCE(ET_PRODUCTS) TYPE  ZKK_TT_PRODUCTS
*"----------------------------------------------------------------------

  APPEND VALUE #( productid = iv_productid
                  sproductname = iv_productname
                  ssupplierid = IV_SUPPLIERDID
                  scategoryid = IV_CATEGORYID
                  squaperunit = iv_quantityperunit
                  sunitprice = iv_unitprice
                  sunitsonorder = iv_unitonorder
                  sreorderlevel = iv_reorderlevel
                  sdiscontinued = iv_discontinued )
  TO et_products.


  MODIFY zkk_products FROM TABLE et_products.

  SELECT * FROM zkk_products
  INTO TABLE @et_products.

ENDFUNCTION.
