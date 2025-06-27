CLASS zcl_sql2_01_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sql2_01_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*   """""OPERADORES BINARIOS
    "EQ --- =  --- EQUAL
    "NE --- <> --- NOT EQUAL
    "LT --- <  --- LESS THAN
    "LE --- <= --- LESS EQUAL
    "GT --- >  --- GREATER THAN
    "GE --- >= --- GREATER EQUAL


    SELECT FROM zflight_joh
    FIELDS *
    WHERE airline_id = 'AA'
    INTO TABLE @DATA(lt_flight).

    IF sy-subrc EQ 0.
      out->write( lt_flight ).
      out->write( | | ).
    ENDIF.


*    """""BETWEEN (CON OPERADORES BINARIOS)

    SELECT FROM zflight_joh
    FIELDS *
    WHERE  flight_date GE '20250101'    "SE TRAE LOS VUELOS ENTRE DOS FECHAS
       AND flight_date LE '20251231'
    INTO TABLE @lt_flight.

    IF sy-subrc EQ 0.
      out->write( lt_flight ).
      out->write( | | ).
    ENDIF.


*    """""BETWEEN

    SELECT FROM zflight_joh
    FIELDS *
    WHERE flight_date BETWEEN '20250101' AND '20251231'  "SE TRAE LOS VALORES DENTRO DEL RANGO
    INTO TABLE @lt_flight.

    IF sy-subrc EQ 0.
      out->write( lines( lt_flight ) ). "MUESTRA LA CANTIDAD DE REGISTROS QUE TIENE LA ITAB
      out->write( | | ).
    ENDIF.


*   """""NOT BETWEEN

    SELECT FROM zflight_joh
    FIELDS *
    WHERE flight_date NOT BETWEEN '20250101' AND '20251231'  "SE TRAE LOS VALORES FUERA DEL RANGO
    INTO TABLE @lt_flight.

    IF sy-subrc EQ 0.
      out->write( data = lt_flight name = 'NOT BETWEEN' ). "MUESTRA LOS REGISTROS QUE TIENE LA ITAB, FUERA DEL RANGO
      out->write( | | ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
