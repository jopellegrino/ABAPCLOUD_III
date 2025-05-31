CLASS zcl_01_itab_practica DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_01_ITAB_PRACTICA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*       EJERCICIO 1: FILTRAR DATOS
*   - CREA UNA TABLA INTERNA CON LOS SIGUIENTES CAMPOS: VUELO, CANTIDAD, Y PRECIO.
*   - LLENA LA TABLA INTERNA CON DATOS SIMULADOS.
*   - ESCRIBE UN PROGRAMA QUE FILTRE LOS VUELOS CUYO PRECIO SEA MAYOR A UN VALOR DETERMINADO (POR EJEMPLO, 3000) UTILIZANDO ESTRUCTURAS DE CONTROL COMO IF O LOOP

    TYPES: BEGIN OF ty_FLIGHT,
             vuelo_id      TYPE /dmo/carrier_id,
             connection_id TYPE /dmo/connection_id,
             price         TYPE /dmo/flight_price,
           END OF ty_flight.

    DATA: lt_FLIGHT TYPE STANDARD TABLE OF ty_FLIGHT WITH NON-UNIQUE KEY VUELO_id,
          ls_FLIGHT TYPE ty_FLIGHT.


    SELECT carrier_id AS vuelo_id, connection_id, price
    FROM /dmo/flight
    INTO CORRESPONDING FIELDS OF TABLE @lt_FLIGHT.

    SORT lt_flight BY price.

    out->write( data = lt_flight name = 'Tabla Entera' ).

    out->write( |Vuelo_id Connection_id Price| ).


    LOOP AT lt_flight INTO ls_FLIGHT WHERE price > 3000.
      out->write( |{ ls_FLIGHT-vuelo_id }       { ls_FLIGHT-connection_id }          { lS_FLIGHT-price }         |  ).
    ENDLOOP.
    out->write( | | ).


*       EJERCICIO 1: FILTRAR VUELOS POR PRECIO
*   - DECLARA UNA TABLA INTERNA BASADA EN LA TABLA /DMO/FLIGHT.
*   - LLÉNALA CON DATOS DE LA BASE DE DATOS.
*   - IMPLEMENTA UN LOOP PARA FILTRAR LOS VUELOS CUYO PRECIO SEA MAYOR A 5000 Y ALMACÉNALOS EN OTRA TABLA INTERNA.
*   - IMPRIME LOS RESULTADOS.

    DATA: lt_flights_02 TYPE STANDARD TABLE OF /dmo/flight WITH NON-UNIQUE KEY client,
          lt_flights_03 TYPE STANDARD TABLE OF /dmo/flight WITH NON-UNIQUE KEY client.


    SELECT FROM /dmo/flight
    FIELDS *
    INTO TABLE @lt_flights_02.

    IF sy-subrc = 0.

      lt_flights_03 = VALUE #( FOR ls_flights_02 IN lt_flights_02 WHERE ( price > 5000 )
                                 ( client           = ls_flights_02-client
                                   carrier_id       = ls_flights_02-carrier_id
                                   connection_id    = ls_flights_02-connection_id
                                   flight_date      = ls_flights_02-flight_date
                                   price            = ls_flights_02-price
                                   currency_code    = ls_flights_02-currency_code
                                   plane_type_id    = ls_flights_02-plane_type_id
                                   seats_max        = ls_flights_02-seats_max
                                   seats_occupied   = ls_flights_02-seats_occupied ) ).
    ENDIF.

    SORT lt_flights_03 BY price.

    out->write( data = lt_flights_03 name = 'Vuelos precios mayor a 5000' ).


*        EJERCICIO 2: CONTAR RESERVAS POR AEROLÍNEA
*    - CREA UNA TABLA INTERNA BASADA EN /DMO/BOOKING.
*    - LLÉNALA CON LOS DATOS DE LA BASE DE DATOS.
*    - USA UN LOOP CON UNA ESTRUCTURA CONDICIONAL IF PARA CONTAR CUÁNTAS RESERVAS EXISTEN POR CADA CARRIER_ID.
*    - ALMACENA LOS RESULTADOS EN UNA TABLA INTERNA Y MUÉSTRALOS EN PANTALLA.

    SELECT FROM /dmo/booking
    FIELDS *
    INTO TABLE @DATA(lt_booking).

    IF sy-subrc = 0.
      LOOP AT lt_booking INTO DATA(ls_booking)

    GROUP BY ( carrier_id        = ls_booking-carrier_id
               cantidad_reservas = GROUP SIZE             ) WITHOUT MEMBERS INTO DATA(gs_key).

        out->write( data = gs_key ).

      ENDLOOP.
    ENDIF.


*       EJERCICIO 3: CALCULAR INGRESOS POR DESTINO
*     - DEFINE UNA TABLA INTERNA QUE ALMACENE LOS VUELOS Y SUS PRECIOS DE /DMO/FLIGHT.
*     - USA UN LOOP PARA RECORRER LOS REGISTROS Y SUMAR LOS PRECIOS DE LOS VUELOS POR CADA DESTINO.
*     - GUARDA LOS TOTALES EN UNA TABLA INTERNA Y ORDÉNALOS POR INGRESOS DESCENDENTES.

    TYPES: BEGIN OF lty_flight_04,
             flight_to TYPE /dmo/carrier_id,
             price     TYPE /dmo/flight_price,
           END OF lty_flight_04.

    TYPES: BEGIN OF lty_flight_total,
             flight_to   TYPE /dmo/carrier_id,
             price       TYPE /dmo/flight_price,
             price_total TYPE /dmo/flight_price,
           END OF lty_flight_total.

    DATA: lt_flight_04    TYPE STANDARD TABLE OF lty_flight_04 WITH NON-UNIQUE KEY flight_to,
          lt_member       TYPE STANDARD TABLE OF lty_flight_04 WITH NON-UNIQUE KEY flight_to,
          gt_members      TYPE /dmo/flight,
          number          TYPE i,
          lt_flight_total TYPE STANDARD TABLE OF lty_flight_total.


    SELECT carrier_id AS flight_to, price
    FROM /dmo/flight
    INTO TABLE @lt_flight_04.


    IF sy-subrc = 0.
      LOOP AT lt_flight_04 INTO DATA(ls_fligh_04)

    GROUP BY ls_fligh_04-flight_to INTO DATA(ls_key_flight).

        CLEAR lt_member.

        LOOP AT GROUP ls_key_flight INTO DATA(ls_member).
          lt_member = VALUE #( BASE lt_member ( ls_member ) ).
        ENDLOOP.
        out->write( data = lt_member ).


        CLEAR number.

        LOOP AT lt_member INTO ls_member.
          number = ( number + ls_member-price ).
        ENDLOOP.

        out->write( data = number name = 'Ganancia por vuelo' ).


      ENDLOOP.
    ENDIF.

*       EJERCICIO 5: LISTAR RESERVAS RECIENTES
*     - LLENA UNA TABLA INTERNA CON LOS DATOS DE /DMO/flight.
*     - USA UN LOOP AT JUNTO CON UNA CONDICIÓN IF PARA FILTRAR LAS RESERVAS HECHAS EN LOS ÚLTIMOS 30 DÍAS.
*     - IMPRIME LOS RESULTADOS EN UN FORMATO CLARO.

    SELECT FROM /dmo/flight
    FIELDS *
    INTO TABLE @DATA(lt_booking_date).

    TYPES lty_date_range TYPE RANGE OF /dmo/flight-flight_date.

    DATA(lt_date_range) = VALUE lty_date_range( ( sign = 'I'
                                                  option = 'BT'
                                                  low = cl_abap_context_info=>get_system_date(  ) - 365
                                                  high = cl_abap_context_info=>get_system_date(  ) ) ).

    LOOP AT lt_booking_date INTO DATA(ls_booking_date) WHERE flight_date IN lt_date_range.

      out->write( ls_booking_date ).


    ENDLOOP.



  ENDMETHOD.
ENDCLASS.
