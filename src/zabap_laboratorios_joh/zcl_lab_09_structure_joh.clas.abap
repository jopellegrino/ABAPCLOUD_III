CLASS zcl_lab_09_structure_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_09_STRUCTURE_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "1. DECLARACION DE ESTRUCTURAS
    TYPES: BEGIN OF ty_flights,
             iduser     TYPE c LENGTH 40,
             aircode    TYPE /dmo/carrier_id,
             flightnum  TYPE /dmo/connection_id,
             key        TYPE land1,
             seat       TYPE /dmo/plane_seats_occupied,
             flightdate TYPE /dmo/flight_date,
           END OF ty_flights,

           BEGIN OF ty_airlines,
             carrid    TYPE /dmo/carrier_id,
             connid    TYPE /dmo/connection_id,
             countryfr TYPE land1,
             cityfrom  TYPE /dmo/city,
             airpfrom  TYPE /dmo/airport_id,
             countryto TYPE land1,
           END OF ty_airlines.

    "2. ESTRUCTURAS ANIDADAS
    TYPES: BEGIN OF ty_nested,
             lty_flights  TYPE ty_flights,
             lty_airlines TYPE ty_airlines,
           END OF ty_nested.

    "3. ESTRUCTURAS COMPLEJAS (DEEP)
    TYPES: BEGIN OF ty_deep,
             carrid  TYPE /dmo/carrier_id,
             connid  TYPE /dmo/connection_id,
             flights TYPE TABLE OF ty_flights WITH EMPTY KEY,
           END OF ty_deep.

    "4. AÑADIR DATOS
    DATA: LS_flights  TYPE ty_flights,
          LS_airlines TYPE ty_airlines,
          LS_nested   TYPE ty_nested,
          LS_deep     TYPE ty_deep.



    LS_flights = VALUE #( iduser = 'USER007' aircode = 'CO4' flightnum = 411 key = 'RE4' seat = 54 flightdate = '20251010' ).
    LS_airlines = VALUE #( carrid = '444' connid = '555'  countryfr = 'US'  cityfrom = 'CH'  airpfrom = 'IL'  countryto = 'PT'   ).
    LS_nested = VALUE #( lty_flights = LS_flights lty_airlines = LS_airlines ).




    LS_deep = VALUE #( carrid = 'AB4' connid = '4456' ).

    SELECT client AS iduser,
    carrier_id AS aircode,
    seats_occupied AS seat,
    flight_date AS flightdate
     FROM /dmo/flight
    INTO CORRESPONDING FIELDS OF TABLE @LS_deep-flights
     UP TO 4 ROWS.
    out->write( data = LS_deep name = 'Nombre: Estructura profunda' ).


    "5. ESTRUCTURA INCLUDE
    TYPES BEGIN OF ty_include_flights.
    INCLUDE TYPE ty_flights AS flights.
    INCLUDE TYPE ty_airlines AS airlines.
    TYPES END OF ty_include_flights.

    DATA ls_INCLUDE_FLIGHTS TYPE ty_include_flights. "INSTANCIA DE LA ESTRUCUTRA INCLUDE


    ls_INCLUDE_FLIGHTS = VALUE #( flights = LS_flights

    airlines-carrid = 'ID7'
    airlines-connid = 555
    airlines-countryfr = 'PT4'
    airlines-cityfrom = 'Galicia'
    airlines-airpfrom = 'ES'
    airlines-countryto = 'FR' ).

    out->write( data = ls_INCLUDE_FLIGHTS name = 'Nombre: Estructura Include' ).

    CLEAR LS_deep.
    CLEAR ls_INCLUDE_FLIGHTS.

    out->write( data = ls_INCLUDE_FLIGHTS name = 'Nombre: Estructura Include (Clear)' ).
    out->write( data = LS_deep name = 'Nombre: Estructura profunda (Clear)' ).
  ENDMETHOD.
ENDCLASS.
