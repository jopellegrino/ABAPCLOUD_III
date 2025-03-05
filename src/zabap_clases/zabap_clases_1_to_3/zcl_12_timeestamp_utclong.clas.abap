CLASS zcl_12_timeestamp_utclong DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_12_timeestamp_utclong IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.



    DATA: lv_time1 TYPE utclong, "TIPO CON FORMATO ISO 8601 (AAAA/MM/DD + HH:MM:SS:MSMSMSMS)
          lv_time2 TYPE utclong,
          lv_date  TYPE d,
          lv_time3 TYPE t.


    "SOLO PARA FORMATO UTC LONG

    lv_time1 = utclong_current(  ). "FUNCION QUE OBTIENE EL TIEMPO ACTUAL DEL SV DE APPS

    out->write( | TIEMPO ACTUAL DEL SV DE APPS: { lv_time1 }| ).

    lv_time1 = utclong_add( val = lv_time1 days = 1 hours = -1 ). "FUNCION PARA (+) O (-) DIAS,HORAS,MIN ETC

    out->write( | TIEMPO DEL SV DE APPS MENOS 1H MAS 1DIA: { lv_time1 }| ). "+1DIA Y -1H


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lv_time1 = utclong_current(  ).

    lv_time2 = utclong_current(  ).

    lv_time2 = utclong_add( val = lv_time2 hours = -5 ). "SE LE RESTA 5H AL HORARIO ACTUAL DEL SV


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA(lv_total) = utclong_diff( high = lv_time1 low = lv_time2 ). "RESTA DE DOS HORARIOS EN UTCLONG

    out->write( | DOS TIEMPOS EN UTCLONG RESTADOS: { lv_total }| ). "RESULTADO EN SEG.

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "CONVERTIR UTCLONG EN UTC (FECHA Y HORAS)

    CONVERT UTCLONG lv_time1
    TIME ZONE cl_abap_context_info=>get_user_time_zone(  ) "LA ZONA HORARIA QUE QUEREMOS TRANSFORMAR EL DATO UTCLONG, CON LA CLASE Y SU METODO
    INTO DATE lv_date
    TIME lv_time3.

    out->write( | Fecha en UTC(user):{ lv_DATE DATE = USER }  | ). "FECHA Y HORA DEL USER OBTENIDA POR UTCLONG CONVERTIDO A UTC
    out->write( | Hora en UTC(user):{ lv_time3 TIME = USER }  | ).



  ENDMETHOD.
ENDCLASS.
