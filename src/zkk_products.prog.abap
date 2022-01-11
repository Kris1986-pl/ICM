*&---------------------------------------------------------------------*
*& Report ZKK_PRODUCTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_products.

DATA lr_costom_container TYPE REF TO cl_gui_custom_container.

CALL SCREEN 100.




*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'PRODUCTS_STATUS'.
* SET TITLEBAR 'xxx'.

  IF lr_costom_container IS NOT BOUND.

    lr_costom_container = NEW #( container_name = 'G_CONTAINER' ).

    DATA(lr_alv) = NEW cl_gui_alv_grid( i_parent = lr_costom_container ).

    SELECT * FROM zkk_products
    INTO TABLE @DATA(lt_products).

    SELECT * FROM zkk_categories
    FOR ALL ENTRIES IN @lt_products
    WHERE zkk_categoryid = @lt_products-scategoryid
    INTO TABLE @DATA(lt_categories).

    SELECT * FROM zkk_suppliers
    FOR ALL ENTRIES IN @lt_products
    WHERE zkk_supplierid = @lt_products-ssupplierid
    INTO TABLE @DATA(lt_suppliers).

    DATA(lt_fieldcat) = VALUE lvc_t_fcat(
                                        ( fieldname = 'Sproductname' edit = abap_true )
                                        ( fieldname = 'SSUPPLIERID' edit = abap_true )
                                        ( fieldname = 'SCATEGORYID' edit = abap_true )
                                        ( fieldname = 'SQUAPERUNIT' edit = abap_true )
                                        ( fieldname = 'SUNITPRICE' edit = abap_true )
*                                        ( fieldname = 'SUNITPRICE' edit = abap_true datatype = 'DEC' decimals_out = '2' )
                                        ( fieldname = 'sunitsonorder' edit = abap_true )
                                        ( fieldname = 'SREORDERLEVEL' edit = abap_true )
                                        ( fieldname = 'SDISCONTINUED' edit = abap_true )
                                        ).

    lr_alv->set_table_for_first_display(
      CHANGING
        it_outtab                     = lt_products               " Output Table
        it_fieldcatalog               = lt_fieldcat               " Field Catalog
      EXCEPTIONS
        invalid_parameter_combination = 1                " Wrong Parameter
        program_error                 = 2                " Program Errors
        too_many_lines                = 3                " Too many Rows in Ready for Input Grid
        OTHERS                        = 4
    ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.

    WHEN 'BACK'.
      SET SCREEN 0.
  ENDCASE.

ENDMODULE.
