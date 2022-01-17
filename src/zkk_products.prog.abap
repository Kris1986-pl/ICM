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
          sproductname       TYPE zkk_products-sproductname,
          ssupplierid        TYPE zkk_products-ssupplierid,
          scategoryid        TYPE zkk_products-scategoryid,
          squaperunit        TYPE zkk_products-squaperunit,
          sunitprice         TYPE zkk_products-sunitprice,
          sunitsonorder      TYPE zkk_products-sunitsonorder,
          sreorderlevel      TYPE zkk_products-sreorderlevel,
          sdiscontinued      TYPE zkk_products-sdiscontinued,
          zkk_categoriesname TYPE zkk_categories-zkk_categoriesname,
          celltab            TYPE lvc_t_styl.
  TYPES:END OF ty_table.

  DATA: ls_table  TYPE ty_table,
        lt_table  TYPE STANDARD TABLE OF ty_table,
        ls_layout TYPE lvc_s_layo.

  IF lr_costom_container IS NOT BOUND.

    lr_costom_container = NEW #( container_name = 'G_CONTAINER' ).

    DATA(lr_alv) = NEW cl_gui_alv_grid( i_parent = lr_costom_container ).

    SELECT sproductname, scategoryid, sdiscontinued, squaperunit, sreorderlevel, ssupplierid,
    sunitprice, sunitsonorder,  zkk_categoriesname FROM zkk_products
    JOIN zkk_categories ON zkk_products~scategoryid = zkk_categories~zkk_categoryid
    INTO TABLE @DATA(lt_products).

*    SELECT * FROM zkk_categories
*    FOR ALL ENTRIES IN @lt_products
*    WHERE zkk_categoryid = @lt_products-scategoryid
*    INTO TABLE @DATA(lt_categories).
*
*    SELECT * FROM zkk_suppliers
*    FOR ALL ENTRIES IN @lt_products
*    WHERE zkk_supplierid = @lt_products-ssupplierid
*    INTO TABLE @DATA(lt_suppliers).

    LOOP AT lt_products REFERENCE INTO DATA(lr_products).
      ls_table = CORRESPONDING #( lr_products->* ).


      APPEND VALUE #( fieldname = 'SCATEGORYID' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SDISCONTINUED' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SPRODUCTNAME' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SQUAPERUNIT' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SREORDERLEVEL' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SSUPPLIERID' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SUNITPRICE' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SUNITSONORDER' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'zkk_categoriesname' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.


      APPEND ls_table TO lt_table.

    ENDLOOP.

    DATA(lt_fieldcat) = VALUE lvc_t_fcat(
                                        ( fieldname = 'SPRODUCTNAME' edit = abap_true ref_table = 'zkk_products' )
                                        ( fieldname = 'SCATEGORYID' edit = abap_true )
                                        ( fieldname = 'zkk_categoriesname' edit = abap_true coltext = 'Categorie Name' )
                                        ( fieldname = 'SSUPPLIERID' edit = abap_true )
                                        ( fieldname = 'SQUAPERUNIT' edit = abap_true )
                                        ( fieldname = 'SUNITPRICE' edit = abap_true )
                                        ( fieldname = 'SUNITSONORDER' edit = abap_true )
                                        ( fieldname = 'SREORDERLEVEL' edit = abap_true )
                                        ( fieldname = 'SDISCONTINUED' edit = abap_true )
                                        ).

    DATA(lt_dis_toolbar) = VALUE ui_functions(
                                             ( cl_gui_alv_grid=>mc_fc_loc_delete_row )
                                             ( cl_gui_alv_grid=>mc_fc_loc_insert_row )
                                             ( cl_gui_alv_grid=>mc_fc_loc_copy_row )
                                             ).

    ls_layout-stylefname = 'CELLTAB'.

    lr_alv->set_table_for_first_display(
      EXPORTING
        is_layout = ls_layout
        it_toolbar_excluding = lt_dis_toolbar
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
