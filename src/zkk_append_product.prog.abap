*&---------------------------------------------------------------------*
*& Report zkk_append_product
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_append_product.

SELECT productid FROM zkk_products INTO @DATA(pa_pid). "Fetch Product ID form table Products
ENDSELECT.

*WRITE: 'Product ID: ' COLOR COL_POSITIVE,
*       p_pid COLOR COL_POSITIVE.

ADD 1 TO pa_pid. "Add 1 to Product ID

PARAMETERS: pa_name TYPE zkk_products-sproductname,
            pa_sid  TYPE zkk_products-ssupplierid,
            pa_cid  TYPE zkk_products-scategoryid,
            pa_qpu  TYPE zkk_products-squaperunit,
            pa_up   TYPE zkk_products-sunitprice,
            pa_uon  TYPE zkk_products-sunitsonorder,
            pa_rl   TYPE zkk_products-sreorderlevel,
            pa_dis  TYPE zkk_products-sdiscontinued.

DATA: lt_products TYPE zkk_tt_products.

APPEND VALUE #( productid = pa_pid sproductname = pa_name ssupplierid = pa_sid scategoryid = pa_cid squaperunit = pa_qpu sunitprice = pa_up sunitsonorder = pa_uon sreorderlevel = pa_rl sdiscontinued = pa_dis )
TO lt_products.

*INSERT INTO scarr VALUES @scarr_wa.
*APPEND ls_products TO lt_products.

MODIFY zkk_products FROM TABLE lt_products.
*DELETE
IF sy-subrc = 0.
  MESSAGE 'Insert OK' TYPE 'S'.
ELSE.
  MESSAGE 'Error during insert' TYPE 'E'.
ENDIF.
