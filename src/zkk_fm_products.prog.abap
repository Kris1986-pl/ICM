*&---------------------------------------------------------------------*
*& Report zkk_fm_products
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_fm_products.

DATA: lt_products TYPE zkk_tt_products.

PARAMETERS: pa_name TYPE zkk_products-sproductname,
            pa_sid  TYPE zkk_products-ssupplierid,
            pa_cid  TYPE zkk_products-scategoryid,
            pa_qpu  TYPE zkk_products-squaperunit,
            pa_up   TYPE zkk_products-sunitprice,
            pa_uon  TYPE zkk_products-sunitsonorder,
            pa_rl   TYPE zkk_products-sreorderlevel,
            pa_dis  TYPE zkk_products-sdiscontinued.

INITIALIZATION.

SELECT SINGLE MAX( productid ) FROM zkk_products INTO @DATA(lv_pid). "Fetch Product ID form table Products
ADD 1 TO lv_pid. "Add 1 to Product ID

  CALL FUNCTION 'ENQUEUE_EZKK_LO_PRODUCTS'
    EXCEPTIONS
      foreign_lock   = 1                " Object already locked
      system_failure = 2                " Internal error from enqueue server
      OTHERS         = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

END-OF-SELECTION.

  CALL FUNCTION 'ZKK_ADD_PRODUCT'
    EXPORTING
      iv_productid       = lv_pid
      iv_productname     = pa_name
      iv_categoryid      = pa_cid
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

  CALL FUNCTION 'DEQUEUE_EZKK_LO_PRODUCTS'.

  cl_demo_output=>display(
    EXPORTING
      data = lt_products
      name = 'Products'
  ).
