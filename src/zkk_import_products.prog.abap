*&---------------------------------------------------------------------*
*& Report zkk_import_products
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_import_products.

DATA: ls_products TYPE zkk_str_products,
      lt_products TYPE zkk_tt_products.

lt_products = VALUE #(
                        ( productid = 1 sproductname = 'Chai' ssupplierid = 8 scategoryid = 1 squaperunit = '10 boxes x 30 bags' sunitprice = 18 sunitsonorder = 0 sreorderlevel = 10 sdiscontinued = 1 )
                        ( productid = 2 sproductname = 'Chang' ssupplierid = 1 scategoryid = 1 squaperunit = '24 - 12 oz bottles' sunitprice = 19 sunitsonorder = 40 sreorderlevel = 25 sdiscontinued = 1 )
*                         ( productid = 2 sproductname = 'Chang' ssupplierid = 1 scategoryid = 1 squaperunit = '24 - 12 oz bottles' sunitprice = 19 sunitsonorder = 40 sreorderlevel = 25 sdiscontinued = 1 )
                     ).

MODIFY zkk_products from table lt_products.

IF sy-subrc = 0.
    MESSAGE 'Insert OK' TYPE 'S'.
   ELSE.
   MESSAGE 'Error during insert' TYPE 'E'.
ENDIF.
