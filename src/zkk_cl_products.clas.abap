CLASS zkk_cl_products DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    TYPES: ty_table_of_zkk_products TYPE STANDARD TABLE OF zkk_products WITH DEFAULT KEY.
    METHODS get_items_from_db
      RETURNING
        VALUE(lt_result) TYPE ty_table_of_zkk_products.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZKK_CL_PRODUCTS IMPLEMENTATION.


  METHOD get_items_from_db.
    SELECT *
    FROM zkk_products
    into table @lt_result.
  ENDMETHOD.
ENDCLASS.
