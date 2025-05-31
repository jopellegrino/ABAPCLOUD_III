CLASS zcl_09_truncamiento_y_redondeo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_09_TRUNCAMIENTO_Y_REDONDEO IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_string TYPE string VALUE 'LOGALI',
          lv_char   TYPE c LENGTH 2,
          lv_int    TYPE i,
          lv_num    TYPE n LENGTH 6.

    DATA:lv_date    TYPE d,
         lv_decimal TYPE p LENGTH 3 DECIMALS 2.

    "TRUNCAMIENTO
    lv_char = lv_string. "
    out->write( |String(6):{ lv_string }| ).
    out->write( |String(6) en Char(2):{ lv_char }| ). "TRUNCAMIENTO PERDIENDO VALORES DE LA VARIABLE

    out->write( | | ).

    "ROUNDING
    lv_decimal = 1 / 12.
    out->write( |Tipo P: 1/12 is rounded to { lv_decimal }| ).


  ENDMETHOD.
ENDCLASS.
