*&---------------------------------------------------------------------*
*& Report ZKK_PRODUCTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_products.

TYPES:BEGIN OF ty_table,
        productid          TYPE zkk_products-productid,
        sproductname       TYPE zkk_products-sproductname,
        ssupplierid        TYPE zkk_products-ssupplierid,
        scategoryid        TYPE zkk_products-scategoryid,
        squaperunit        TYPE zkk_products-squaperunit,
        sunitprice         TYPE zkk_products-sunitprice,
        sunitsinstock      TYPE zkk_unit_in_stock,
        sunitsonorder      TYPE zkk_products-sunitsonorder,
        sreorderlevel      TYPE zkk_products-sreorderlevel,
        sdiscontinued      TYPE zkk_products-sdiscontinued,
        scategoriesname TYPE zkk_categories-scategoriesname,
        zkk_companyname    TYPE zkk_suppliers-zkk_companyname,
        celltab            TYPE lvc_t_styl.
TYPES:END OF ty_table.

TYPES: ty_tab_products TYPE STANDARD TABLE OF zkk_products.

DATA: lr_costom_container TYPE REF TO cl_gui_custom_container,
      gt_table            TYPE STANDARD TABLE OF ty_table.



CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.
    METHODS handle_data_changed
                FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.

    METHODS get_inserted_rows
      EXPORTING et_inserted_rows TYPE ty_tab_products.

    METHODS get_deleted_rows
      EXPORTING et_deleted_rows TYPE ty_tab_products.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: gt_inserted_rows TYPE ty_tab_products,
*          gt_table         TYPE STANDARD TABLE OF ty_table,
          gt_deleted_rows  TYPE ty_tab_products.

*    DATA: del_row TYPE lvc_s_moce.
*          wa_obj  TYPE zpr_pkp_mgl,
*          pspnr   TYPE zpr_guk_pos-pspnr.

*DATA: gt_table        TYPE STANDARD TABLE OF ty_table,
*      gt_deleted_rows TYPE ty_tab_products.

ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_data_changed.

    DATA ls_inserted_rows TYPE zkk_products.
*    DATA: gt_table        TYPE zkk_products.


    FIELD-SYMBOLS: <lt_table> TYPE STANDARD TABLE,
                   <ls_row>   TYPE ty_table.

    SELECT * FROM zkk_categories INTO TABLE @DATA(lt_categories).
*    select * from zkk_suppliers into table @data(lt_suppliers).

    ASSIGN er_data_changed->mp_mod_rows->* TO <lt_table>.

    LOOP AT er_data_changed->mt_deleted_rows ASSIGNING FIELD-SYMBOL(<fs_deleted_row>).
      DATA(ls_deleted_row) = gt_table[ <fs_deleted_row>-row_id ].
      gt_deleted_rows = VALUE #( BASE gt_deleted_rows ( CORRESPONDING #( ls_deleted_row ) ) ).
    ENDLOOP.

    LOOP AT <lt_table> ASSIGNING <ls_row>.

      READ TABLE lt_categories WITH KEY scategoryid = <ls_row>-scategoryid REFERENCE INTO
      DATA(lr_categories).


      IF sy-subrc = 0.
        <ls_row>-scategoriesname = lr_categories->scategoriesname.
      ENDIF.

      ls_inserted_rows = CORRESPONDING #( <ls_row> ).
      APPEND ls_inserted_rows TO gt_inserted_rows.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_inserted_rows.
    et_inserted_rows = me->gt_inserted_rows.
  ENDMETHOD.

  METHOD get_deleted_rows.
    et_deleted_rows = me->gt_deleted_rows.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  CALL SCREEN 100.




*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'PRODUCTS_STATUS'.
* SET TITLEBAR 'xxx'.



  DATA: ls_table         TYPE ty_table,
        ls_layout        TYPE lvc_s_layo,
        lr_event_handler TYPE REF TO lcl_event_handler.

  lr_event_handler = NEW #(  ).

  IF lr_costom_container IS NOT BOUND.

    lr_costom_container = NEW #( container_name = 'G_CONTAINER' ).

    DATA(lr_alv) = NEW cl_gui_alv_grid( i_parent = lr_costom_container ).

    SELECT productid, sproductname, zkk_products~scategoryid, sdiscontinued, squaperunit, sreorderlevel, ssupplierid,
    sunitprice, sunitsinstock, sunitsonorder, scategoriesname, zkk_companyname FROM zkk_products
    LEFT JOIN zkk_categories ON zkk_products~scategoryid = zkk_categories~scategoryid
    JOIN zkk_suppliers ON zkk_products~ssupplierid = zkk_suppliers~zkk_supplierid
    INTO TABLE @DATA(lt_products).

    LOOP AT lt_products REFERENCE INTO DATA(lr_products).
      ls_table = CORRESPONDING #( lr_products->* ).

      APPEND VALUE #( fieldname = 'SCATEGORIESNAME' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SCATEGORYID' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SDISCONTINUED' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SPRODUCTNAME' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SQUAPERUNIT' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SREORDERLEVEL' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SSUPPLIERID' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
*      APPEND VALUE #( fieldname = 'SUNITPRICE' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.!
      APPEND VALUE #( fieldname = 'SUNITSINSTOCK' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'SUNITSONORDER' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.
      APPEND VALUE #( fieldname = 'ZKK_COMPANYNAME' style = cl_gui_alv_grid=>mc_style_disabled ) TO ls_table-celltab.


      APPEND ls_table TO gt_table.

    ENDLOOP.

    DATA(lt_fieldcat) = VALUE lvc_t_fcat(
                                        ( fieldname = 'SPRODUCTNAME' edit = abap_true ref_table = 'ZKK_PRODUCTS' )
                                        ( fieldname = 'SCATEGORYID' edit = abap_true ref_table = 'ZKK_PRODUCTS' )
                                        ( fieldname = 'SCATEGORIESNAME' edit = abap_true coltext = 'Categories Name' )
                                        ( fieldname = 'SSUPPLIERID' edit = abap_true ref_table = 'ZKK_PRODUCTS' )
                                        ( fieldname = 'ZKK_COMPANYNAME' edit = abap_true coltext = 'Company Name' )
                                        ( fieldname = 'SQUAPERUNIT' edit = abap_true ref_table = 'ZKK_PRODUCTS' )
                                        ( fieldname = 'SUNITPRICE' edit = abap_true ref_table = 'ZKK_PRODUCTS' datatype = 'DEC' )
                                        ( fieldname = 'SUNITSINSTOCK' edit = abap_true ref_table = 'ZKK_PRODUCTS' )
                                        ( fieldname = 'SUNITSONORDER' edit = abap_true ref_table = 'ZKK_PRODUCTS' )
                                        ( fieldname = 'SREORDERLEVEL' edit = abap_true ref_table = 'ZKK_PRODUCTS' )
                                        ( fieldname = 'SDISCONTINUED' edit = abap_true ref_table = 'ZKK_PRODUCTS' )
                                        ).

    DATA(lt_dis_toolbar) = VALUE ui_functions(
*                                             ( cl_gui_alv_grid=>mc_fc_loc_delete_row )
                                             ( cl_gui_alv_grid=>mc_fc_loc_insert_row )
*                                             ( cl_gui_alv_grid=>mc_fc_loc_copy_row )
                                             ).

    ls_layout-stylefname = 'CELLTAB'.

    SET HANDLER lr_event_handler->handle_data_changed FOR lr_alv.

    lr_alv->set_table_for_first_display(
      EXPORTING
        is_layout = ls_layout
        it_toolbar_excluding = lt_dis_toolbar
      CHANGING
        it_outtab                     = gt_table         " Output Table
        it_fieldcatalog               = lt_fieldcat      " Field Catalog
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

    WHEN 'SAVE'.
      lr_alv->check_changed_data(
        IMPORTING
          e_valid   = DATA(lv_valid)
        ).

      IF lv_valid IS NOT INITIAL.

        lr_event_handler->get_inserted_rows(
            IMPORTING
                et_inserted_rows = DATA(lt_inserted_rows)
        ).

        lr_event_handler->get_deleted_rows(
            IMPORTING
              et_deleted_rows = DATA(lt_deleted_rows)
          ).

        IF lt_inserted_rows IS NOT INITIAL.

          SELECT MAX( productid ) FROM zkk_products INTO @DATA(lv_max_productid).

          LOOP AT lt_inserted_rows REFERENCE INTO DATA(lr_inserted_rows).
            IF lv_max_productid = 0.
              lv_max_productid = lv_max_productid + 1.
              lr_inserted_rows->productid = lv_max_productid.
            ENDIF.
          ENDLOOP.

          MODIFY zkk_products FROM TABLE lt_inserted_rows.


        ELSEIF lt_deleted_rows IS NOT INITIAL.

          DELETE zkk_products FROM TABLE lt_deleted_rows.

        ENDIF.

      ENDIF.

      IF sy-subrc = 0.
        MESSAGE 'Seved' TYPE 'S'.
      ELSE.
        MESSAGE 'Error during save' TYPE 'E'.
      ENDIF.
  ENDCASE.

ENDMODULE.
