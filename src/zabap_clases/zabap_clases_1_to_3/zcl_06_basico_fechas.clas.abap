CLASS zcl_06_basico_fechas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_06_BASICO_FECHAS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_date TYPE d.
    lv_date = '20240101'.
    lv_date = lv_date + 31. "SUMA 31 DIAS A LA FECHA

    out->write( | { lv_date+6(2) }/{ lv_date+4(2) }/{ lv_date+0(4) } | ). "el numero sumado al date es la posicion y el () es la cantidad tomada desde la posicion

  ENDMETHOD.
ENDCLASS.
