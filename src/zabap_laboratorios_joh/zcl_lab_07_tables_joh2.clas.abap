CLASS zcl_lab_07_tables_joh2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_07_TABLES_JOH2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    """"""1. FOR(LLENAR UNA ITAB USANDO EL ITERADOR DEL FOR)

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


    """"""2. FOR ANIDADO (LLENAR UNA ITAB A PARTIR DE 2 ITAB)

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


    """"""3. AÑADIR MULTIPLES LINEAS (SELECT)(LLENAR PARCIALMENTE UNA ITAB A PARTIR DE OTRA (AMBAS DEL MISMO TIPO)

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


    """""4. ORDENAR REGISTROS (ORDENAR LA ITAB POR EL CAMPO connection_id, DE FORMA DESCENDENTE

    SORT mt_airlines BY connection_id DESCENDING.

    out->write( EXPORTING data = mt_airlines name = 'mt_airlines (SORT)' ).
    out->write( | | ).


    """""5. MODIFICAR REGISTROS (MODIFICAR LA HORA DE SALIDA A HORA ACTUAL DE LOS VUELOS > 12:00:00)

    DATA mt_spfli TYPE STANDARD TABLE OF /dmo/connection.

    SELECT FROM /dmo/connection
    FIELDS *
    WHERE carrier_id = 'LH'
    INTO TABLE @mt_spfli.

    LOOP AT mt_spfli INTO DATA(ms_spfli).
      IF ms_spfli-departure_time > '120000'.

        MODIFY mt_spfli FROM VALUE #( departure_time = cl_abap_context_info=>get_system_time( )
                                                       ) TRANSPORTING departure_time.

      ENDIF.
    ENDLOOP.

    out->write( EXPORTING data = mt_spfli name = 'mt_spfli (Modify Departure_time)' ).
    out->write( | | ).


    "OTRA FORMA

    LOOP AT mt_spfli INTO ms_spfli.
      IF ms_spfli-departure_time > '12:00:00'.

        ms_spfli-departure_time = cl_abap_context_info=>get_system_time( ).
        MODIFY mt_spfli FROM ms_spfli TRANSPORTING departure_time.

      ENDIF.
    ENDLOOP.

    out->write( EXPORTING data = mt_spfli name = 'mt_spfli (Modify Departure_time)' ).
    out->write( | | ).



    """""6.ELIMINAR REGISTROS (ELIMINAR REGISTROS DE UNA ITAB, DONDE UN CAMPO = 'FRA'

    LOOP AT mt_spfli INTO DATA(ms_spfli_02).
      IF ms_spfli_02-airport_to_id = 'FRA'.

        DELETE TABLE mt_spfli FROM ms_spfli_02.

      ENDIF.
    ENDLOOP.

    out->write( EXPORTING data = mt_spfli name = 'mt_spfli (Del. Airport_to_id = FRA)' ).
    out->write( | | ).


    "OTRA FORMA
    DELETE mt_spfli WHERE airport_to_id = 'FRA'.
    out->write( EXPORTING data = mt_spfli name = 'mt_spfli (Del. Airport_to_id = FRA (2))' ).
    out->write( | | ).


    """"""7. CLEAR / FREE (LIMPIAR Y LIBERAR ESPACIO EN MEMORIA OCUP. POR UNA ITAB)

    CLEAR mt_airlines.
    out->write( EXPORTING data = mt_airlines name = 'mt_airlines (CLEAR)' ).
    out->write( | | ).

    FREE mt_airlines.
    out->write( EXPORTING data = mt_airlines name = 'mt_airlines (FREE)' ).
    out->write( | | ).


    """""""""8. INSTRUCCION COLLECT

    TYPES: BEGIN OF ty_seats,                                                                 "DECLARACION DE TIPO LOCAL
             carrier_id    TYPE /dmo/carrier_id,
             connection_id TYPE /dmo/connection_id,
             seats         TYPE /dmo/plane_seats_occupied,
             bookings      TYPE /dmo/flight_price,
           END OF ty_seats.

    DATA: lt_seats   TYPE HASHED TABLE OF ty_seats WITH UNIQUE KEY carrier_id connection_id,    "DECLARACION DE TABLAS INTERNAS
          lt_seats_2 TYPE STANDARD TABLE OF ty_seats WITH NON-UNIQUE KEY carrier_id,
          lS_seats   TYPE ty_seats.


    SELECT                                       "CONSULTA A /DMO/flight, TOMANDO SOLO UNOS CAMPOS Y VOLCARLO EN ITAB
    carrier_id,
    connection_id,
    seats_occupied AS seats,
    price          AS bookings
    FROM /dmo/flight
    WHERE seats_max = 140
    INTO CORRESPONDING FIELDS OF TABLE @lt_seats.

    SELECT
    carrier_id,
    connection_id,
    seats_occupied AS seats,
    price          AS bookings
    FROM /dmo/flight
    INTO CORRESPONDING FIELDS OF TABLE @lt_seats_2.

    SELECT
    seats,
    bookings
    FROM @lt_seats_2 AS lt_SEATS_2_alias
    INTO CORRESPONDING FIELDS OF @lS_seats.

      COLLECT lS_seats INTO lt_seats.

    ENDSELECT.

    out->write( EXPORTING data = lt_seats name = 'lt_seats (COLLECT)' ).
    out->write( | | ).


    "OTRA FORMA

    SELECT DISTINCT carrier_id, connection_id, seats_occupied AS seats, price AS bookings  "NO TRAE DUPLICADOS
    FROM /dmo/flight
    WHERE seats_max = '140'
    INTO TABLE @lt_seats.

    SELECT carrier_id, connection_id, seats_occupied AS seats, price AS bookings
    FROM /dmo/flight
    INTO TABLE @lt_seats_2.

    LOOP AT lt_seats_2 INTO DATA(ls_seats_2).
      COLLECT ls_seats_2 INTO lt_seats.
    ENDLOOP.

    out->write( EXPORTING data = lt_seats name = 'lt_seats (COLLECT)' ).
    out->write( | | ).


    """"""9. INSTRUCCION LET (ALMACENAR EN UNA VAR. LOS VALORES DE `carrier_id DE mt_scarr` Y `price DE mt_flights_type`)

    SELECT FROM /dmo/flight
    FIELDS *
    INTO TABLE @mt_flights_type.

    SELECT FROM /dmo/carrier
    FIELDS *
    INTO TABLE @DATA(mt_scarr).

    DATA(lv_let_try) = CONV string( LET lv_carrier_id = mt_scarr[ 1 ]-carrier_id
                                        lv_price_id = mt_flights_type[ 1 ]-price

                                        IN |Carrier_Id: { lv_carrier_id } / Price: { lv_price_id }  | ).

    out->write( |Instruccion LET: { lv_let_try } | ).
    out->write( | | ).



    """""""10. INSTRUCION BASE (ASIGNAR LOS VALORES Y COLOCAR COMO BASE DE mt_flights_type A lt_flights_base)

    DATA lt_flights_base TYPE STANDARD TABLE OF /dmo/flight.

    lt_flights_base = VALUE #( BASE mt_flights_type ( carrier_id = 'LS'
                                                      connection_id = '2500'
                                                      flight_date = cl_abap_context_info=>get_system_date(  )
                                                      price = '2000'
                                                      currency_code = 'USD'
                                                      plane_type_id = 'A380-800'
                                                      seats_max = 120
                                                      seats_occupied = 100  ) ).

    out->write( EXPORTING data = lt_flights_base name = 'lt_flights_base (BASE)' ).
    out->write( | | ).



    """"""11. AGRUPACION DE REGISTROS (AGRUPAR POR LOS CAMPOS airport_from_id Y MOSTRAR LOS MIEMBROS DE LA AGRUPACION)

    SELECT FROM /dmo/connection
    FIELDS *
    INTO TABLE @mt_spfli.

    DATA gt_member LIKE mt_spfli.

    LOOP AT mt_spfli INTO DATA(ms_spfli_wa)                          "RECORRE LA TABLA Y ASINGA LAS CLASES DE GRUPOS

      GROUP BY ms_spfli_wa-airport_from_id.

      CLEAR gt_member.                                               "LIMPIA LA TABLA USADA PARA GUARDAR LOS GRUPOS PARA VOLVERLA A USAR

      LOOP AT GROUP ms_spfli_wa INTO DATA(ms_spfli_wa_02).           "RECORRE LOS GRUPOS Y LOS APILA
        gt_member = VALUE #( BASE gt_member ( ms_spfli_wa_02 ) ).
      ENDLOOP.
      out->write( EXPORTING data = gt_member ).                                "IMPRIME C/U GRUPO ENTERO

    ENDLOOP.
    out->write( | | ).



    """"""12. AGRUPAR POR CLAVE (AGRUPAR POR DOS CAMPOS, MOSTRAR TODOS LOS MIEMBROS Y ASIGNAR UNA CLAVE PARA LA AGRUPACION)

    LOOP AT mt_spfli INTO ms_spfli_wa

  GROUP BY ( from = ms_spfli_wa-airport_from_id
             to   = ms_spfli_wa-airport_to_id  ) INTO DATA(gs_key).

      CLEAR gt_member.

      LOOP AT GROUP gs_key INTO ms_spfli_wa_02.
        gt_member = VALUE #( BASE gt_member ( ms_spfli_wa_02 ) ).
      ENDLOOP.
      out->write( EXPORTING data = gs_key name = 'gs_key' ).
      out->write( EXPORTING data = gt_member ).

    ENDLOOP.

    DATA lty_groups_key LIKE mt_spfli.
    out->write( | | ).



    """""""13. FOR GROUPS
    TYPES lty_group_keys TYPE STANDARD TABLE OF /dmo/connection-carrier_id WITH EMPTY KEY.

    out->write( VALUE lty_group_keys( FOR GROUPS gv_group OF gs_group IN mt_spfli
                                      GROUP BY gs_group-carrier_id
                                      ASCENDING
                                      WITHOUT MEMBERS ( gv_group ) ) ).



    """""""14.TABLAS DE RANGOS

    DATA lt_range TYPE RANGE OF /dmo/flight-seats_occupied.  "TABLA DE RANGOS seats_occupied

    lt_range = VALUE #( ( sign = 'I'                         "INCLUIR seats_occupied Between 200-400
                          option = 'BT'
                          low = '200'
                          high = '400' ) ).

    SELECT FROM /dmo/flight
    FIELDS *
    WHERE seats_occupied IN @lt_range                        "USANDO TABLA DE RANGOS COMO FILTRO
    INTO TABLE @mt_flights_type.

    out->write( EXPORTING data = lt_range name = 'lt_range' ).
    out->write( EXPORTING data = mt_flights_type name = 'mt_flights_type' ).
    out->write( | | ).


    """""""15. ENUMERACIONES

    TYPES: BEGIN OF ENUM mty_currency STRUCTURE ls_currency,
             c_initial,
             c_dollar,
             c_euros,
             c_colpeso,
             c_mexpeso,
           END OF ENUM mty_currency STRUCTURE ls_currency.

    DATA lv_currency TYPE mty_currency.

    out->write( EXPORTING data = lv_currency name = 'lv_currency' ).

    lv_currency = ls_currency-c_colpeso.

    CASE lv_currency.
      WHEN ls_currency-c_initial.
        out->write( 'The currency is Initial' ).
      WHEN ls_currency-c_dollar.
        out->write( 'The currency is USD' ).
      WHEN ls_currency-c_euros.
        out->write( 'The currency is EUR' ).
      WHEN ls_currency-c_colpeso.
        out->write( 'The currency is COP' ).
      WHEN ls_currency-c_mexpeso.
        out->write( 'The currency is MEX' ).
    ENDCASE.


  ENDMETHOD.
ENDCLASS.
