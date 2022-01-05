*&---------------------------------------------------------------------*
*& Report zkk_oo_products
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zkk_oo_products.

class lcl_main definition create private.

  public section.

    CLASS-METHODS create
      RETURNING
        value(r_result) TYPE REF TO lcl_main.

    methods run.

  protected section.
  private section.

endclass.

class lcl_main implementation.
  method create.
    create object r_result.
  endmethod.

  method run.
    data(products) = new zkk_cl_products( ).
    data(products_items) = products->get_items_from_db( ).

       cl_salv_table=>factory(
         IMPORTING
           r_salv_table   = data(alv_table)
          CHANGING
            t_table        = products_items ).

       alv_table->display(  ).

 endmethod.
endclass.

start-of-selection.
lcl_main=>create( )->run( ).
