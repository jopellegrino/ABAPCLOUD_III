CLASS zcl_lab_01_advqueries_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_01_advqueries_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*   "DECLARACION EN LINEA

    DATA: lv_carrierid TYPE string,
          lv_filtro    TYPE i.

    lv_carrierid = 'A'.
    lv_filtro = 500.

    SELECT FROM /dmo/flight
    FIELDS @lv_carrierid AS carrier_id,
            connection_id
    WHERE price GT @lv_filtro
    INTO TABLE @DATA(lt_flights).

    IF sy-subrc EQ 0.
      out->write( lt_flights ).
    ELSE.
      out->write( |'NO DATA' | ).
    ENDIF.

    out->write( | | ).

*    "CASE (CREAR UNA CAMPO EN UNA ITAB USANDO CONDICIONES CASE A PARTIR DE DATOS DE LA BBDD)

    SELECT FROM /dmo/flight
    FIELDS MAX( price ) AS MaxPrice,
           MIN( price ) AS MinPrice
    INTO ( @DATA(MaxPrice), @DATA(MinPrice) ).



    SELECT FROM /dmo/flight
    FIELDS  carrier_id,
            connection_id,
            price,
            CASE
               WHEN price > @MaxPrice - division( @MaxPrice - @MinPrice, 3, 2 )  THEN 'HIGH'
               WHEN price < @MinPrice + division( @MaxPrice - @MinPrice, 3, 2 )  THEN 'LOW'
               WHEN price < @MaxPrice - division( @MaxPrice - @MinPrice, 3, 2 )
                    AND price > @MinPrice + division( @MaxPrice - @MinPrice, 3, 2 ) THEN 'MEDIUM'
                              END AS Category
    ORDER BY price
    INTO TABLE @DATA(lt_flights2).

    IF sy-subrc EQ 0.
      out->write( lt_flights2 ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).

*    "TABLAS TEMPORALES GLOBALES (TABLA TEMPORAL GLOBAL, PARA HACER JOIN)

    INSERT ztemp_flight_joh FROM ( SELECT FROM /dmo/flight
                                          FIELDS *
                                          WHERE carrier_id    EQ 'SQ'
                                            AND connection_id EQ 0001     ).

    IF sy-subrc EQ 0.
      out->write( |Datos Insertados correctamente { sy-dbcnt } | ).
    ELSE.
      out->write( 'Insercion Fallida' ).
    ENDIF.

    SELECT FROM /dmo/flight AS Flight
           INNER JOIN ztemp_flight_joh AS FlightTemp ON flight~carrier_id EQ FlightTemp~carrier_id
                                                      AND flight~connection_id EQ FlightTemp~connection_id
    FIELDS flight~carrier_id,
           flight~connection_id,
           FlightTemp~connection_id AS TemporaryConnection,
           FlightTemp~carrier_id    AS TemporaryCarrierId
    INTO TABLE @DATA(lt_inner_temp).

    IF sy-subrc EQ 0.
      out->write( data = lt_inner_temp name = 'INNER JOIN WITH TEMPORARY' ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*    "SUBCONSULTA - WITH (TABLA TEMPORAL DE HOST PARA HACER UN JOIN, Y DEJAR TODO EN HANA)

    out->write( 'SUBCONSULTA - WITH' ).

    WITH +tmp_flight AS ( SELECT FROM /dmo/flight
                          FIELDS carrier_id,
                                 connection_id,
                                 flight_date
                          WHERE price GT 500     )

     SELECT FROM /dmo/flight AS Flight

     INNER JOIN +tmp_flight AS Tmp_flight
            ON Tmp_flight~carrier_id EQ Flight~carrier_id
            AND Tmp_flight~connection_id EQ Flight~connection_id

     FIELDS Flight~carrier_id,
            Flight~connection_id,
            Flight~price,
            Flight~flight_date
     ORDER BY price
     INTO TABLE @DATA(lt_flight_temp).

    IF sy-subrc EQ 0.
      out->write( data = lt_flight_temp name = 'INNER JOIN WITH+' ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*   "INSERCION / MODIFICACION -SUBCONSULTA

    DELETE FROM zspfli_joh.
    out->write( |INSERCION / MODIFICACION - SUBCONSULTA | ).

    INSERT zspfli_joh FROM ( SELECT FROM /dmo/carrier AS carrier
                             FIELDS carrier~carrier_id AS carrier_id,
                                    carrier~name AS name,
                                    carrier~currency_code AS currency_code
                             WHERE currency_code EQ 'EUR'  ).

    COMMIT WORK.

    IF sy-subrc EQ 0.
      out->write( |Registros insertados correctamente { sy-dbcnt }| ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    SELECT FROM zspfli_joh
    FIELDS *
    INTO TABLE @DATA(lt_result_sub).

    IF sy-subrc EQ 0.
      out->write( name = 'SUBCONSULTA' data = lt_result_sub ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.
    out->write( | | ).


*   "DATABASE HINTS

    out->write( 'DATABASE HINTS' ).

    MODIFY zdmo_flight_joh FROM ( SELECT FROM /dmo/flight
                                    FIELDS *                ).

    TRY.

        SELECT FROM zdmo_flight_joh
        FIELDS carrier_id,
               connection_id,
               price
       %_HINTS HDB 'INDEX_SEARCH'
        INTO TABLE @FINAL(LT_FlightHints).

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql_Db).
        out->write( lx_sql_Db->get_text(  ) ).
    ENDTRY.

    IF sy-subrc EQ 0.
      out->write( LT_FlightHints ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*   "UNION

    out->write( |UNION | ).

    SELECT FROM /dmo/flight
    FIELDS carrier_id,
           connection_id,
           price
    WHERE price LT 4000

    UNION ALL

    SELECT FROM /dmo/flight
    FIELDS carrier_id,
           connection_id,
           price
    WHERE price GT 6000

    ORDER BY price

    INTO TABLE @DATA(lt_union_flight).

    IF sy-subrc EQ 0.
      out->write( lt_union_flight ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*    "INTERSECT

    out->write( |INTERSECT| ).

    SELECT FROM /dmo/flight
    FIELDS carrier_id,
           connection_id,
           price
    WHERE price GT 4000

    INTERSECT

      SELECT FROM /dmo/flight
    FIELDS carrier_id,
           connection_id,
           price
    WHERE price LT 6000
    ORDER BY price

    INTO TABLE @DATA(lt_intersect_flights).

    IF sy-subrc EQ 0.
      out->write( lt_intersect_flights ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*   "EXCEPT

    out->write( |EXCEPT| ).

    SELECT FROM /dmo/flight
    FIELDS carrier_id,
           connection_id,
           price
    WHERE price GT 4000

           EXCEPT

        SELECT FROM /dmo/flight
    FIELDS carrier_id,
           connection_id,
           price
    WHERE price GT 6000

        INTO TABLE @DATA(lt_EXCEPT_flights).

    IF sy-subrc EQ 0.
      out->write( lt_EXCEPT_flights ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.








  ENDMETHOD.
ENDCLASS.
