CLASS zcl_11_oper_date_y_time DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_11_oper_date_y_time IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_date  TYPE d,
          lv_date2 TYPE d,
          lv_time  TYPE t,
          lv_time2 TYPE c LENGTH 6.

    lv_date = cl_abap_context_info=>get_system_date(  ). "CLASE GLOBAL, Y LLAMAMOS AL METODO (DA LA FECHA ACTUAL UTC)
    lv_time = cl_abap_context_info=>get_system_time(  ). "LLAMAMOS AL METODO QUE DA HORA ACTUAL EN EL SV EN UTC
    lv_time2 = cl_abap_context_info=>get_user_time_zone(  ). "METODO ZONA HORARIA (EL ERROR IGUAL PERMITE USARLA)

    out->write( | Fecha del Sv UTC: { lv_date }| ).
    out->write( | Hora del Sv UTC: { lv_time }| ).
    out->write( | Zona horario del User: { lv_time2 }| ).

    out->write( | | ).

    lv_date = '20250101'.
    lv_date2 = '20250130'.

    DATA(lv_days) = lv_date2 - lv_date. "CONVIERTE LAS FECHAS EN UN I DE DIAS Y RESTA LOS DIAS, LO MISMO CON LA HORA TRANSFORMADOLA EN SEG. DESDE LA MEDIA NOCHE.
    out->write( | La diferencia entre: { lv_date2 DATE = USER   } y { lv_date DATE = USER } es de { lv_days } Dias| ).

  ENDMETHOD.
ENDCLASS.
