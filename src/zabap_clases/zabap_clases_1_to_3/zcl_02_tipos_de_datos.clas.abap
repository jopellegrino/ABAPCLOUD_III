CLASS zcl_02_tipos_de_datos DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_02_TIPOS_DE_DATOS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_string TYPE string,
          lv_int    TYPE i VALUE 20241008,
          lv_date   TYPE d VALUE '20241008'.

    lv_string = '20241008'.

    TYPES: BEGIN OF lty_flight,
             name  TYPE string,
             price TYPE i,
           END OF lty_flight.

    out->write( lv_string ).
    out->write( lv_int ).
    out->write( lv_date ).


  ENDMETHOD.
ENDCLASS.
