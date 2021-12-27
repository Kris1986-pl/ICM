*&---------------------------------------------------------------------*
*& Report zkk_append_product
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_append_product.

CALL FUNCTION 'ENQUEUE_EZKK_LO_PRODUCTS'
*  EXPORTING
*    mode_zkk_products = 'X'              " Lock mode for table ZKK_PRODUCTS
*    productid         =                  " 01th enqueue argument
*    x_productid       = space            " Fill argument 01 with initial value?
*    _scope            = '2'
*    _wait             = space
*    _collect          = ' '              " Initially only collect lock
  EXCEPTIONS
    foreign_lock      = 1                " Object already locked
    system_failure    = 2                " Internal error from enqueue server
    others            = 3
  .
IF sy-subrc <> 0.
 MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.


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

DATA: lt_products TYPE zkk_tt_products.

APPEND VALUE #( productid = pa_pid
                sproductname = pa_name
                ssupplierid = pa_sid
                scategoryid = pa_cid
                squaperunit = pa_qpu
                sunitprice = pa_up
                sunitsonorder = pa_uon
                sreorderlevel = pa_rl
                sdiscontinued = pa_dis )
TO lt_products.

MODIFY zkk_products FROM TABLE lt_products.

IF sy-subrc = 0.
  MESSAGE 'Insert OK' TYPE 'S'.
ELSE.
  MESSAGE 'Error during insert' TYPE 'E'.
ENDIF.
