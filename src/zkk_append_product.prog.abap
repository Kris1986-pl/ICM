*&---------------------------------------------------------------------*
*& Report zkk_append_product
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_append_product.

SELECT productid FROM zkk_products INTO @DATA(p_pid). "Fetch Product ID form table Products
ENDSELECT.

*WRITE: 'Product ID: ' COLOR COL_POSITIVE,
*       p_pid COLOR COL_POSITIVE.

ADD 1 TO p_pid. "Add 1 to Product ID

PARAMETERS: p_name type zkk_products-sproductname,
            p_sid  type zkk_products-ssupplierid,
            s_cid  type zkk_products-scategoryid,
            s_qpu  type zkk_products-squaperunit,
            s_up   type zkk_products-sunitprice,
            s_uon   type zkk_products-sunitsonorder,
            s_rl    type zkk_products-sreorderlevel,
            s_dis   type zkk_products-sdiscontinued.

DATA: ls_products TYPE zkk_str_products,
      lt_products TYPE zkk_tt_products.

ls_products = value #( productid = p_pid sproductname = p_name ssupplierid = p_sid scategoryid = s_cid squaperunit = s_qpu sunitprice = s_up sunitsonorder = s_uon sreorderlevel = s_rl sdiscontinued = s_dis ).

APPEND ls_products to lt_products.

MODIFY zkk_products from table lt_products.

IF sy-subrc = 0.
    MESSAGE 'Insert OK' TYPE 'S'.
   ELSE.
   MESSAGE 'Error during insert' TYPE 'E'.
ENDIF.
