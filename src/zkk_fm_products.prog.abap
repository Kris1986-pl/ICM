*&---------------------------------------------------------------------*
*& Report zkk_fm_products
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_fm_products.

DATA: lt_products TYPE zkk_tt_products.

SELECT productid FROM zkk_products INTO @DATA(pa_pid). "Fetch Product ID form table Products
ENDSELECT.

ADD 1 TO pa_pid. "Add 1 to Product ID

PARAMETERS: pa_name    TYPE zkk_products-sproductname,
            pa_sid(10) MATCHCODE OBJECT zkk_hlp_supplierid,
            pa_cid(10) MATCHCODE OBJECT zkk_hlp_categoryid,
            pa_qpu     TYPE zkk_products-squaperunit,
            pa_up      TYPE zkk_products-sunitprice,
            pa_uon     TYPE zkk_products-sunitsonorder,
            pa_rl      TYPE zkk_products-sreorderlevel,
            pa_dis     TYPE zkk_products-sdiscontinued.



CALL FUNCTION 'ZKK_ADD_PRODUCT'
  EXPORTING
    iv_productid       = pa_pid
    iv_productname     = pa_name
    iv_categotyid      = pa_cid
    iv_supplierdid     = pa_sid
    iv_quantityperunit = pa_qpu
    iv_unitprice       = pa_up
    iv_unitonorder     = pa_uon
    iv_reorderlevel    = pa_rl
    iv_discontinued    = pa_dis
  IMPORTING
    et_products        = lt_products.

IF sy-subrc = 0.
  MESSAGE 'Insert OK' TYPE 'S'.
ELSE.
  MESSAGE 'Error during insert' TYPE 'E'.
ENDIF.

cl_demo_output=>display(
  EXPORTING
    data = lt_products
    name = 'Products'
).
