*&---------------------------------------------------------------------*
*& Report zkk_avl_products
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_avl_products.

DATA(lt_fieldcat) = VALUE slis_t_fieldcat_alv(
                                             ( fieldname = 'PRODUCTID' key = abap_true )
                                             ( fieldname = 'Sproductname' edit = abap_true )
                                             ( fieldname = 'SSUPPLIERID' edit = abap_true )
                                             ( fieldname = 'SCATEGORYID' edit = abap_true )
                                             ( fieldname = 'SQUANTITY_PER_UNIT' edit = abap_true )
                                             ( fieldname = 'SUNITPRICE' edit = abap_true )
                                             ( fieldname = 'sunitsonorder' edit = abap_true )
                                             ( fieldname = 'SREORDERLEVEL' edit = abap_true )
                                             ( fieldname = 'SDISCONTINUED' edit = abap_true )
                                             ).

SELECT * FROM zkk_products
INTO TABLE @DATA(lt_products).

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_callback_program      = sy-repid          " Name of the calling program
    i_callback_user_command = 'SAVE'            " EXIT routine for command handling
    it_fieldcat             = lt_fieldcat       " Field catalog with field descriptions
  TABLES
    t_outtab                = lt_products       " Table with data to be displayed
  EXCEPTIONS
    program_error           = 1                 " Program errors
    OTHERS                  = 2.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

CALL FUNCTION 'DEQUEUE_EZKK_LO_PRODUCTS'.
cl_demo_output=>display(
  EXPORTING
    data = lt_products
    name = 'Products'
).

FORM save USING rcomm TYPE sy-ucomm
sel TYPE slis_selfield.
  CASE sy-ucomm.
    WHEN '&DATA_SAVE'.

      LOOP AT lt_products INTO DATA(ls_products).

        CALL FUNCTION 'ENQUEUE_EZKK_LO_PRODUCTS'
          EXPORTING
            mode_zkk_products = 'X'
            productid         = ls_products-productid
          EXCEPTIONS
            foreign_lock      = 1                " Object already locked
            system_failure    = 2                " Internal error from enqueue server
            OTHERS            = 3.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

      ENDLOOP.

      MODIFY zkk_products FROM TABLE lt_products.

      IF sy-subrc = 0.
        MESSAGE 'Seved' TYPE 'S'.
      ELSE.
        MESSAGE 'Error during save' TYPE 'E'.
      ENDIF.
  ENDCASE.

ENDFORM.
