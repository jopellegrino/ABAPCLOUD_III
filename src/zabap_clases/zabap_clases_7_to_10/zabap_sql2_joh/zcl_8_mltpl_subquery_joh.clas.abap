CLASS zcl_8_mltpl_subquery_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_8_MLTPL_SUBQUERY_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*   "LLENAR DE DATOS zflight_joh
    DELETE FROM zflight_joh.

    DATA lt_flight TYPE STANDARD TABLE OF zflight_joh.

    SELECT FROM /dmo/flight
    FIELDS carrier_id     AS airline_id,
           plane_type_id  AS plane_type,
           seats_max      AS maximum_seats,
           seats_occupied AS occupiedseats,
           Connection_id, flight_date, price, currency_code
    INTO CORRESPONDING FIELDS OF TABLE @lt_flight.

    INSERT zflight_joh FROM TABLE @lt_flight.



*   """""AS - NOMBRE ALTERNATIVO (ALIAS)

    out->write( |"""""AS"""""| ).

    SELECT FROM zflight_joh AS flight                        "TAMBIEN ES POSIBLE COLOCAR ALIAS A LA FUENTE DE DATOS
        FIELDS flight~airline_id     AS airline,             "AGREGAR EL AS A LA FUENTE ES UTIL PARA PODER DECIR DE DONDE SE TOMARA UN CAMPO ESPECIFICO CON ~, UTIL CUANDO HAY INNER JOIN
               flight~connection_id  AS connection,
               SUM( price ) AS price
               GROUP BY flight~airline_id, connection_id      "NO SE PUEDE USAR EL ALIAS EN LAS AGRUPACIONES EN CAMPOS, YA QUE LA AGRUPACION SE HACE ANTES DE LA ASIGNACION DE LOS ALIAS POR ENDE NO LOS LEE
    INTO TABLE @DATA(lt_flights).


    IF sy-subrc EQ 0.
      out->write( lt_flights ).
    ENDIF.

    out->write( | | ).


*   """""SUBQUERY (SELECIONAR DATOS DE UNA FUENTE, EN BASE A DATOS DE LA COND. DE OTRA QUERY)

    TRY.

        out->write( |"""""SUBQUERY"""""| ).

        SELECT FROM /dmo/i_flight                              "SELECIONAR LOS VUELOS QUE TENGA EL PRECIO MAS BAJO, OSEA SOLO LOS DUPLICADOS DEL LITERAL MAS BAJO
           FIELDS *
           WHERE price EQ ( SELECT FROM /dmo/i_flight          "ESTA QUERY DEVUELVE SOLO CAMPOS IGUALES A LOS DE /DMO/I_FLIGHT-PRICE, SE COMPARA LA MISMA FUENTE CON ELLA MISMA
                                   FIELDS MIN( price )   )     "COMPARA UNO A UNO LOS EL CAMPO PRICE DE TODOS LOS REGISTROS DE LA PRIMERA QUERY, CON EL CAMPO MINPRICE DE LA SUBQUERY QUE ES ELLA MISMA
           INTO TABLE @DATA(lt_flight_lowcost).


        IF sy-subrc EQ 0.
          out->write( lt_flight_lowcost ).
        ELSE.
          out->write( 'NO DATA' ).
        ENDIF.

        out->write( | | ).

*        """""""ESTO NO SE PUEDE HACER"""""""

        SELECT FROM /dmo/i_flight                                        "LAS FUENTES PUEDEN SER DIFERENTES QUE TENGAN UN CAMPO EN COMUN
        FIELDS *
        WHERE airlineid EQ ( SELECT FROM /dmo/I_connection              "EN SUBQUERY NO FUNCIONA SELECT SINGLE
                               FIELDS AirlineID
                               WHERE DepartureAirport EQ 'JFK'  )       "EL PROBLEMA ES QUE ESTA SUBQUERY DEVUELVE MULTIPLES REGISTROS, Y EL SELECT PRINCIPAL TRAE UNO A UNO LOS REGISTROS
       INTO TABLE @lt_flight_lowcost.                                   "Y NO ES POSIBLE COMPARAR LOS REGISTROS DE LA SELECT PRINC. CON LOS MULTIPLES REGISTROS DE LA SUBQUERY (QUE TRAE UNA TABLA)
        "PARA QUE FUNCIONE LA SUBQUERY DEBE DEVOLVER UN SOLO REGISTRO

        IF sy-subrc EQ 0.
          out->write( lt_flight_lowcost ).
        ELSE.
          out->write( 'NO DATA' ).
        ENDIF.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql_db).
        out->write( lx_sql_db->get_text(  ) ).

    ENDTRY.

    out->write( | | ).

*    """""SUBQUERY ALL (OBTENER EL CODIGO DE LA COMPAÑIA AEREA CON LA MAYOR CANTIDAD DE VUELO EN LA FUENTE DE DATOS)

    out->write( |"""""SUBQUERY ALL"""""| ).

    SELECT FROM /dmo/i_flight
    FIELDS AirlineID,
           COUNT( * ) AS FlightAvailable              "ESTO ME DA LA CANTIDAD DE AIRLINEID QUE EXISTEN
           GROUP BY AirlineID                         "AGRUPA TODOS LAS CANTIDADES A UN AIRLINEID
           ORDER BY FlightAvailable DESCENDING        "ORDENA DE FORMA DECENDIENTE PARA QUE EL AIRLINEID CON MAS CANTIDAD ESTE DE PRIMERO
           INTO TABLE @DATA(lt_flights_2)
           UP TO 1 ROWS.                              "TRAE SOLO EL MAYOR

    IF sy-subrc EQ 0.
      out->write( lt_flights_2 ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.


    """""FORMA 2

    SELECT FROM /dmo/i_flight
    FIELDS AirlineID,
       COUNT( * ) AS FlightAvailable
       GROUP BY AirlineID                                     "HASTA AQUI DICE, DAME UN AGRUPA AQUELLAS COMPAÑIAS AEREAS
       HAVING COUNT( * ) GE ALL ( SELECT FROM /dmo/i_flight   "CUYO CONTADOR (COUNT) ES MAYOR O IGUAL
                                           FIELDS COUNT( * )  "QUE LA AGRUPACION DEL MAYOR REGISTROS QUE TENEMOS DE ESTA SUBQUERY
                                           GROUP BY AirlineID   )
       INTO TABLE @DATA(lt_flights_3).

    out->write( | | ).

*   """""SUBQUERY ANY-SOME (PERMITE COLOCAR UNA SELECT QUE DEVUELVE MULTIPLES REGISTROS (UN TABLA) Y HACER LA COMPARACION EN EL FILTRO WHERE DE LA SELECT PRINCIPAL)

    out->write( |"""""SUBQUERY ANY-SOME"""""| ).   "VUELOS DE I_CONNECTION QUE TIENEN EN I_FLIGHT CON ASIENTOSOCUPADOS >= 100, USANDO COMO CAMPO COMUN AIRLINEID

    TRY.
        SELECT FROM /dmo/I_connection AS connection
        FIELDS *
        WHERE airlineid EQ ANY ( SELECT FROM /dmo/I_FLIGHT              "ANY-SOME COMPARA CON CUALQUIER REGISTROS QUE ESTE DENTRO DE LA SUBQUERY CON LA COND. WHERE
                                 FIELDS AirlineID
                                 WHERE OccupiedSeats GE '100'  )        "TRAE DE UNA SEGUNDA FUENTE, LAS AIRLINEID CON MAYOR O IGUAL 10 ASIENTOS OCUPADOS

       INTO TABLE @DATA(lt_flight5).


        IF sy-subrc EQ 0.
          out->write( lt_flight5 ).
          out->write( |Number of flights (ANY-SOME): { lines( lt_flight5 ) } | ).
        ELSE.
          out->write( 'NO DATA' ).
        ENDIF.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql_db2).
        out->write( lx_sql_db->get_text(  ) ).

    ENDTRY.

    out->write( | | ).





  ENDMETHOD.
ENDCLASS.
