*&---------------------------------------------------------------------*
*& Report zkk_load_products
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_load_products.


DATA: lv_dataset      TYPE string,
      lv_dataset_line TYPE string,
      lv_message      TYPE string,
      ls_products     TYPE zkk_str_products,
      lt_products     TYPE zkk_tt_products.

lv_dataset = '/usr/sap/NPL/D00/work/products_data.csv'.

OPEN DATASET lv_dataset FOR INPUT MESSAGE lv_message IN TEXT MODE ENCODING DEFAULT.

IF sy-subrc <> 0.
  WRITE : lv_message.
ENDIF.

DO.
  READ DATASET lv_dataset INTO lv_dataset_line.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  SPLIT lv_dataset_line AT ',' INTO TABLE DATA(lt_split_dataset).

  IF sy-index = 1.
    CLEAR lt_split_dataset.
    CONTINUE.
  ENDIF.

  CHECK lt_split_dataset IS NOT INITIAL.

  ls_products-productid = lt_split_dataset[ 1 ].
  ls_products-sproductname = lt_split_dataset[ 2 ].
  ls_products-ssupplierid = lt_split_dataset[ 3 ].
  ls_products-scategoryid = lt_split_dataset[ 4 ].
  ls_products-squaperunit = lt_split_dataset[ 5 ].
  ls_products-sunitprice = lt_split_dataset[ 6 ].
  ls_products-sunitinstock = lt_split_dataset[ 7 ].
  ls_products-sunitsonorder = lt_split_dataset[ 8 ].
  ls_products-sreorderlevel = lt_split_dataset[ 9 ].
  ls_products-sdiscontinued = lt_split_dataset[ 10 ].

  APPEND ls_products to lt_products.

  MODIFY zkk_products FROM TABLE lt_products.

ENDDO.
CLOSE DATASET lv_dataset.
