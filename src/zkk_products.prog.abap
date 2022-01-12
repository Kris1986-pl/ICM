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

  TYPES:BEGIN OF ty_table,
          sproductname TYPE zkk_products-sproductname,
          celltab      TYPE lvc_t_styl.
  TYPES:END OF ty_table.

  DATA: ls_table  TYPE ty_table,
        lt_table  TYPE STANDARD TABLE OF ty_table,
        ls_layout TYPE lvc_s_layo.

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

    LOOP AT lt_products REFERENCE INTO DATA(lr_products).
      ls_table = CORRESPONDING #( lr_products->* ).

      APPEND VALUE #( fieldname = 'Sproductname' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.

      APPEND ls_table TO lt_table.

    ENDLOOP.

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

    ls_layout-stylefname = 'CELLTAB'.

    lr_alv->set_table_for_first_display(
      EXPORTING
        is_layout = ls_layout
      CHANGING
        it_outtab                     = lt_table               " Output Table
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


    lr_alv->set_ready_for_input(
        i_ready_for_input = 1
    ).

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
