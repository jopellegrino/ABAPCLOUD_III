CLASS zcl_lab_07_tables_joh2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_07_tables_joh2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    """"""1. FOR

    TYPES: BEGIN OF ty_flights,
             iduser     TYPE c LENGTH 40,
             aircode    TYPE /dmo/carrier_id,
             flightnum  TYPE /dmo/connection_id,
             key        TYPE land1,
             seat       TYPE /dmo/plane_seats_occupied,
             flightdate TYPE /dmo/flight_date,
           END OF ty_flights.

    DATA: lt_flights      TYPE TABLE OF ty_flights,
          lt_flights_info TYPE TABLE OF ty_flights.

    lt_flights = VALUE #( FOR i = 1 UNTIL i >= 15
                          ( iduser = | { 1234 + i } - USER |
                            aircode = 'SQ'
                            flightnum = 0000 + i
                            key = 'US'
                            seat = 0 + i
                            flightdate = cl_abap_context_info=>get_system_date(  ) + i ) ).

    out->write( EXPORTING data = lt_flights name = 'LT_FLIGHTS' ).
    out->write( | | ).


    lt_flights_info = VALUE #( FOR GS_lt_flights IN lt_flights
                               ( iduser = GS_lt_flights-iduser
                                 aircode = 'CL'
                                 flightnum = GS_lt_flights-flightnum + 10
                                 flightdate = GS_lt_flights-flightdate
                                 key = 'COP'
                                 seat = GS_lt_flights-seat ) ).

    out->write( EXPORTING data = lt_flights_info name = 'LT_FLIGHTS_INFO' ).
    out->write( | | ).


    """"""2. FOR ANIDADO

    DATA: mt_flights_type TYPE STANDARD TABLE OF /dmo/flight,
          mt_airline      TYPE STANDARD TABLE OF /dmo/connection,
          lt_final        TYPE SORTED TABLE OF ty_flights WITH NON-UNIQUE KEY aircode.

    SELECT FROM /dmo/flight
    FIELDS *
    INTO TABLE @mt_flights_type.

    SELECT FROM /dmo/connection
    FIELDS carrier_id, connection_id, airport_from_id, airport_to_id
    INTO CORRESPONDING FIELDS OF TABLE @mt_airline.




    lt_final = VALUE #( FOR gs_flights_type IN mt_flights_type WHERE ( carrier_id = 'SQ' )
                         FOR gs_airline IN mt_airline WHERE ( connection_id = gs_flights_type-connection_id )

                          ( iduser    = gs_flights_type-client
                            aircode   = gs_flights_type-carrier_id
                            flightnum = gs_airline-connection_id
                            key       = gs_airline-airport_from_id
                            seat      = gs_flights_type-seats_occupied
                            flightdate = gs_flights_type-flight_date ) ).


    out->write( EXPORTING data = lt_final name = 'LT_FLIGHT' ).
    out->write( | | ).


    """"""3. AÑADIR MULTIPLES LINEAS (SELECT)

    TYPES: BEGIN OF ty_airlines,
             carrier_id      TYPE /dmo/carrier_id,
             connection_id   TYPE /dmo/connection_id,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
           END OF ty_airlines.

    DATA mt_airlines TYPE STANDARD TABLE OF ty_airlines.

    SELECT *
    FROM @mt_airline AS airline
    WHERE airport_from_id = 'FRA'
    INTO CORRESPONDING FIELDS OF TABLE  @mt_airlines.

    out->write( EXPORTING data = mt_airlines name = 'mt_airlines' ).
    out->write( | | ).


    """""4. ORDENAR REGISTROS

    SORT mt_airlines BY connection_id DESCENDING.

    out->write( EXPORTING data = mt_airlines name = 'mt_airlines (SORT)' ).
    out->write( | | ).


    """""5. MODIFICAR REGISTROS (MODIFICAR LA HORA DE SALIDA A HORA ACTUAL DE LOS VUELOS > 12:00:00)

    SELECT FROM /dmo/connection
    FIELDS *
    WHERE carrier_id = 'LH'
    INTO TABLE @DATA(mt_spfli).

    LOOP AT mt_spfli INTO DATA(ms_spfli).
      IF ms_spfli-departure_time > '120000'.

        MODIFY mt_spfli FROM VALUE #( departure_time = cl_abap_context_info=>get_system_time( ) )
                                                                          TRANSPORTING departure_time.

      ENDIF.
    ENDLOOP.
    out->write( EXPORTING data = mt_spfli name = 'mt_spfli (Modify Departure_time)' ).




  ENDMETHOD.
ENDCLASS.
