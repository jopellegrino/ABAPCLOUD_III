CLASS zcl_lab_06_selectsql_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_06_selectsql_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "SELECT SINGLE

*    SELECT SINGLE FROM zproducts_joh
*    FIELDS *
*    INTO @DATA(ls_products).
*
*    out->write( |Nombre del producto: { ls_products-product_name }| ).


    "SELECT BYPASSING BUFFER

*    SELECT SINGLE FROM zproducts_joh
*    FIELDS *
*    INTO @DATA(ls_products) BYPASSING BUFFER.
*
*    IF sy-subrc = 0.
*      out->write( |Nombre del producto: { ls_products-product_name }| ).
*    ENDIF.


    "SELECT INTO / APPENDING TABLE

*    SELECT FROM zproducts_joh
*    FIELDS *
*    WHERE category_id > 200
*    INTO TABLE @DATA(lt_products).
*
*    IF sy-subrc = 0.
*      out->write( data = lt_products name = 'ZPRODUCTS_JOH'  ).
*    ENDIF.

    "SELECT INTO CORRESPONDING FIELDS

*    TYPES: BEGIN OF lty_productos2,
*             client       TYPE mandt,
*             product_id   TYPE int8,
*             product_name TYPE c LENGTH 40,
*             category_id  TYPE int8,
*             quantity     TYPE int8,
*             price        TYPE p LENGTH 10 DECIMALS 2,
*           END OF lty_productos2.
*
*    DATA lt_productos2 TYPE STANDARD TABLE OF lty_productos2.
*
*    SELECT FROM zproducts_joh
*    FIELDS *
*    WHERE category_id > 200
*    INTO CORRESPONDING FIELDS OF TABLE @lt_productos2.
*
*    IF sy-subrc = 0.
*      out->write( data = lt_productos2 name = 'ZPRODUCTS_JOH'  ).
*    ENDIF.

*    "SELECT UP TO n Rows
*    SELECT FROM zproducts_joh
*    FIELDS *
*    WHERE category_id > 200
*    INTO TABLE @DATA(lt_products3)
*    UP TO 3 ROWS.
*
*    IF sy-subrc = 0.
*      out->write( data = lt_products3 name = 'ZPRODUCTS_JOH'  ).
*    ENDIF.

    "SELECT / ENDSELECT

    SELECT FROM zproducts_joh
    FIELDS *
    WHERE price >= 10
    INTO TABLE @DATA(lt_products)
    PACKAGE SIZE 2.

      out->write( lt_products ).

    ENDSELECT.



  ENDMETHOD.
ENDCLASS.
