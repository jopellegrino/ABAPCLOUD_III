CLASS zcl_10_joins_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_10_joins_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DELETE FROM zdatasource_1.

    INSERT zdatasource_1 FROM TABLE @(  VALUE #( ( id = 1
                                                   name_1 = 'One'
                                                   datasource_1 = 'DATA Source 1' )

                                                 ( id = 2
                                                   name_1 = 'Two'
                                                   datasource_1 = 'DATA Source 1' )

                                                 ( id = 3
                                                   name_1 = 'Three'
                                                   datasource_1 = 'DATA Source 1' )

                                                 ( id = 4
                                                   name_1 = 'Four'
                                                   datasource_1 = 'DATA Source 1' )

                                                 ( id = 5
                                                   name_1 = 'Five'
                                                   datasource_1 = 'DATA Source 1' ) ) ).


    DELETE FROM zdatasource_2.

    INSERT zdatasource_2 FROM TABLE @(  VALUE #( ( id = 6
                                                   name_2 = 'Six'
                                                   datasource_2 = 'DATA Source 2' )

                                                 ( id = 2
                                                   name_2 = 'Two'
                                                   datasource_2 = 'DATA Source 2' )

                                                 ( id = 3
                                                   name_2 = 'Three'
                                                   datasource_2 = 'DATA Source 2' )

                                                 ( id = 7
                                                   name_2 = 'Seven'
                                                   datasource_2 = 'DATA Source 2' )

                                                 ( id = 8
                                                   name_2 = 'Eight'
                                                   datasource_2 = 'DATA Source 2' ) ) ).


    DELETE FROM zdatasource_3.

    INSERT zdatasource_3 FROM TABLE @(  VALUE #( ( id = 8
                                                   name_3 = 'Eight'
                                                   datasource_3 = 'DATA Source 3' )

                                                 ( id = 9
                                                   name_3 = 'Nine'
                                                   datasource_3 = 'DATA Source 3' )

                                                 ( id = 3
                                                   name_3 = 'Three'
                                                   datasource_3 = 'DATA Source 3' )

                                                 ( id = 10
                                                   name_3 = 'Ten'
                                                   datasource_3 = 'DATA Source 3' )

                                                 ( id = 11
                                                   name_3 = 'Eleven'
                                                   datasource_3 = 'DATA Source 3' ) ) ).


*   """""INNER JOIN"""""(CAMPOS EN COMUN, ENTRE IZQ Y DER. SACANDO EL RESTO)

    out->write( |"""""INNER JOIN"""""| ).

    SELECT FROM zdatasource_1 AS dataS1                                        "FUENTE 1, O IZQ
    INNER JOIN zdatasource_2 AS dataS2 ON dataS1~id EQ dataS2~id               "FUENTE 2, O DER. Y CONDICION PARA AMBAS USANDO LA CLAVE, ESTE ES DONDE EL ID DE AMBOS SEA IGUAL
    FIELDS dataS1~id AS id1,
           dataS2~id AS id2,
           dataS1~name_1,
           dataS1~datasource_1,                                                 "TE TRAES LOS CAMPOS NECESARIOS DE AMBAS FUENTES
           dataS2~name_2,                                                       "COMO EL ID ES LA KEY USADA EN QUE AMBAS SON IGUALES, COMUNMENTE SOLO SE TRAE EL ID DE UNA SOLA FUENTE, YA QUE TODOS LOS CAMPOS ENTRE AMBAS SON IGUALES
           dataS2~datasource_2
    INTO TABLE @DATA(lt_results).

    IF sy-subrc EQ 0.
      Out->write( lt_results ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).



*   "INNER JOIN TRIPLE, SE PUEDEN USAR PARENTESIS PARA CAMBIAR EL ORDEN Y SABER CUALES SE HACEN JUNTOS O SEPARADOS

    SELECT FROM /dmo/i_flight AS flight
    INNER JOIN /DMO/I_Connection AS Connection ON flight~AirlineID     EQ Connection~AirlineID                         "SE USA EL CAMPO CON NOMBRE QUE TIENEN EN COMUN
                                               AND flight~ConnectionID EQ Connection~ConnectionID
    INNER JOIN /DMO/I_Airport AS DepartureAirport ON connection~DepartureAirport EQ DepartureAirport~AirportID         "TRIPLE INTERSECCION, EN DONDE I_Connection-DEPARTUREAIRPORT ES IGUAL /DMO/I_Airport-AIRPORT,
    INNER JOIN /DMO/I_Airport AS destinationAirport ON Connection~destinationAirport EQ destinationAirport~AirportID   "SOLO PARA TENER LOS NOMBRES DE LOS AEROPUER DE SALIDA

    FIELDS flight~AirlineID,                     "YA QUE AMBAS TABLAS TIENEN ESTOS DOS CAMPOS IGUALES PERO EL RESTO DE CAMPOS DISTINTOS. A ESTOS CAMPOS SE LES TRAE SOLOS Y EL RESTO SI DEBES TRAERLO DE AMBAS FUENTES
           flight~FlightDate,                    "POR EJEMPLO FLIGHDATE SOLO ESTA EN I_FLIGHT
           Connection~DepartureAirport,          "Y ESTE CAMPO SOLO LO TIENE I_CONNECTION
           DepartureAirport~name AS DepartureName,
           Connection~destinationAirport,
           destinationAirport~Name AS DestinationName,
           Flight~price,
           flight~currencycode
           INTO TABLE @DATA(lt_flights2).

    IF sy-subrc EQ 0.
      Out->write( lt_flights2 ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).


*   """""LEFT JOIN (LEFT OUTER JOIN)    TRAE TODOS LOS CAMPOS DE LA TABLA A, Y LOS QUE TIENEN EN COMUN A Y B, PERO HACIENDO QUE LOS QUE ESTAN EN COMUN TENGAN MAS CAMPOS QUE SON LOS DE B

    SELECT FROM zdatasource_1 AS dsA                "LOS REGISTROS DE A, TRAIDOS, QUE NO TIENEN NADA EN COMUN CON B, TENDRIAN CAMPOS VACIOS, QUE SERIAN LOS CAMPOS DE B, YA QUE NO TIENEN DATOS EN COMUN
    LEFT JOIN zdatasource_2 AS dsB ON dsA~id EQ dsB~id
    FIELDS dsA~id AS idA,
           dsB~id AS idB,
           dsA~name_1,
           dsB~name_2,
           dsA~datasource_1,
           dsB~datasource_2
           INTO TABLE @DATA(lt_results2).


    IF sy-subrc EQ 0.
      Out->write( lt_results2 ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).


*    """""RIGHT JOIN (RIGHT OUTER JOIN) DEVUELVE LOS REGISTROS COMUNES DE A CON B, Y EL RESTO DE REGISTROS DE B

    SELECT FROM zdatasource_1 AS dsA
    RIGHT JOIN zdatasource_2 AS dsB ON dsA~id EQ dsB~id
    FIELDS dsA~id AS id_A,
           dsB~id AS id_b,
           dsA~name_1,
           dsA~datasource_1,
           dsB~name_2,
           dsB~datasource_2
           order by dsA~name_1 DESCENDING
           INTO TABLE @DATA(lt_results3).

    IF sy-subrc EQ 0.
      Out->write( lt_results3 ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).

  ENDMETHOD.
ENDCLASS.
