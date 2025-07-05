CLASS zcl_4_exprns_agrgcn_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_4_exprns_agrgcn_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""GROUP BY (CUENTA TODOS LOS CONNETIONID DIFERENTES, PARA LOS DIFERENTES AIRLINEID, Y LOS AGRUPA EN UNA TABLA) AIRLINEID -> # CONNECTIONID

    out->write( |"""""GROUP BY"""""| ).

    SELECT FROM /dmo/i_flight   "QUEREMOS EL NUM DE CONEXIONES SIN DUPLICADOS POR CADA COMPAÑIA AEREA
    FIELDS AirlineID,
            COUNT( DISTINCT ConnectionID ) AS CountDistinctConn
       WHERE FlightDate GE '20240101'
       GROUP BY AirlineID                   "SI QUIERES TRAER UN REGISTRO SOLO Y EXISTEN CAMPOS DE AGREGACION COMO COUNT, SUM, ETC, DEBES USAR GRUP BY ESE CAMPO QUE NO TIENE AGREGACION
       INTO TABLE @DATA(lt_conections).     "TODOS LOS CAMPOS DEBEN ESTAR O EN FUNCIONES DE AGREGACION O GROUP BY, NO PUEDES ESTAR SOLOS, SI USAS ALMENOS UNA AGREGACION

    IF sy-subrc = 0.
      out->write( lt_conections ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).


*    """""HAVING (SE AGREGA COMO CRITERIO SOBRE LAS AGREGRACIONES O EL GROUP BY)

    out->write( |"""""HAVING"""""| ).


**********ORDER OF EXECUTION**********
*1. FROM
*2. WHERE (TRUE O FALSE)
*3. GROUP BY
*4. HAVING (FILTRA EN EL GROUP BY)
*5. SELECT
*6. ORDER BY
*7. UP TO (LIMIT)

    SELECT FROM /dmo/i_flight
    FIELDS AirlineID,
            MIN( MaximumSeats ) AS MinSeats,
            MAX( MaximumSeats ) AS MaxSeats
    WHERE flightdate BETWEEN '20240101' AND '20301231'
    GROUP BY AirlineID HAVING AirlineID IN ( 'AA', 'LH', 'UA' )   "UN FILTRO PARECIDO A UN WHERE PERO PARA EL GROUP BY
       INTO TABLE @DATA(lt_results).

    IF sy-subrc = 0.
      out->write( lt_results ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).


*    """""ORDER BY (POR UN CAMPO)(SOLICITAR LA INFORMACION ORDENADA DESCENDENTE O ASCENDENTE)

    out->write( |"""""ORDER BY (CAMPO)"""""| ).

    SELECT FROM /dmo/i_flight
    FIELDS AirlineID,
           ConnectionID,
           FlightDate,
           price,
           CurrencyCode
    WHERE FlightDate BETWEEN '20240101' AND '20301231'
    ORDER BY FlightDate ASCENDING, ConnectionID DESCENDING "ASCENDING           "ORDENA POR LA FECHA ASCENDIENTE Y EL CONNETION ID DE FORMA DECENDENTE
    INTO TABLE @DATA(lt_result2).

    IF sy-subrc = 0.
      out->write( lt_result2 ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).


*    """""ORDER BY (POR UN CAMPO)(SOLICITAR LA INFORMACION ORDENADA DESCENDENTE O ASCENDENTE)

    out->write( |"""""ORDER BY (PRIMARY KEY)"""""| ).

    SELECT FROM /dmo/i_flight
    FIELDS AirlineID,
           ConnectionID,
           FlightDate,
           price,
           CurrencyCode
    WHERE FlightDate BETWEEN '20240101' AND '20301231'
    ORDER BY PRIMARY KEY    "ORDENA POR LAS COLUMNAS CLAVES Y SOLO SE PUEDE ASCENDING, Y NO NECESARIAMENTE TIENES QUE TRAERTE LOS CAMPOS CLAVES EN FIELDS
    INTO TABLE @DATA(lt_result3).

    IF sy-subrc = 0.
      out->write( lt_result3 ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).



    "ORDER BY (NO SE PUEDE USAR CON UN SELECT SINGLE)

    "    **********Order Of Execution**********
*1. FROM
*2. WHERE (TRUE O FALSE)
*3. GROUP BY
*4. HAVING (FILTRA EN EL GROUP BY)
*5. SELECT (FIELDS)
*6. ORDER BY
*7. UP TO (LIMIT)
*8. INTO TABLE

    SELECT FROM /dmo/i_flight                   "1
    FIELDS AirlineID,                           "5      "A PESAR DE QUE SE ORDENA POR EL CURRENCY, AL NO COLOCARLO EN LOS FIELDS, NO SE CREA UN CAMPO PARA EL, Y LA ITAB SOLO DOS CAMPOS (AirlineID y MinPrice)
    MIN( price ) AS MinPrice
    WHERE PlaneType = '767-200'                 "2
    GROUP BY AirlineID, CurrencyCode HAVING CurrencyCode IN ( 'USD', 'EUR' )   "3 y 4 "UN FILTRO PARECIDO A UN WHERE PERO PARA EL GROUP BY
    ORDER BY AirlineID ASCENDING                "6
    INTO TABLE @DATA(lt_results4)               "8
    UP TO 3 ROWS.                               "7

    IF sy-subrc = 0.
      out->write( lt_results4 ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).


*   """""OFFSET""""" (PAGINAR ENTRE UNA GRAN CANTIDAD DE REGISTROS, PARA MOSTRARLOS POR BLOQUES, YA QUE SI SON MUCHOS NO CABEN EN UNA SOLA PAGINA)

    out->write( |"""""OFFSET"""""| ).   "EL UP TO NO FUNCIONA PORQUE SOLO TE TRAE LOS PRIMEROS NOMBRADOS, Y NO TODOS

    DATA: lv_page_numer       TYPE i VALUE 2,        "NUMERO DE PAGINA QUE ES NECESITADA O BLOQUE
          lv_records_per_page TYPE i VALUE 10.       "CANTIDAD DE REGISTROS POR PAGINAS

    DATA gv_offset TYPE int8.                  "VAR PARA LLEVAR UN CALCULO QUE NECESITA LA BBDD PARA IDENTIFICAR EL BLOQUE QUE SE HACE REFERENCIA

    gv_offset =  ( lv_page_numer - 1 ) * lv_records_per_page.   "EL -1 ES PORQUE LA BBDD EL INCIO ES EN CERO, Y LA VAR lv_page_numer ES PARA EL USER QUE PARA EL SERIA PAG 1

    SELECT FROM /DMO/I_Flight
        FIELDS *
        WHERE CurrencyCode = 'USD'
        ORDER BY AirlineID, ConnectionID, FlightDate ASCENDING
        INTO TABLE @DATA(lt_results5)
        OFFSET @gv_offset
        UP TO @lv_records_per_page ROWS.

    IF sy-subrc = 0.
      out->write( lt_results5 ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).



  ENDMETHOD.
ENDCLASS.
