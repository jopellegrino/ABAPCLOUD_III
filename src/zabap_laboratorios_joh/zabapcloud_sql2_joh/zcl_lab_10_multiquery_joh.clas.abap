CLASS zcl_lab_10_multiquery_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_10_MULTIQUERY_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  "1.AS - NOMBRE ALTERNATIVO

*    SELECT FROM /dmo/carrier
*    FIELDS carrier_id AS carrier,
*           name       AS name
*    INTO TABLE @DATA(lt_carrier).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_carrier ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*    "2.SUBQUERY

*    SELECT FROM /dmo/flight
*    FIELDS plane_type_id, price
*    WHERE price GT ( SELECT FROM /dmo/flight
*                     FIELDS MIN( price ) )
*    ORDER BY price ASCENDING
*    INTO TABLE @DATA(lt_flight_price).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_flight_price ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*    "3.SUBQUEY ALL

*    SELECT FROM /dmo/flight
*    FIELDS connection_id
*    WHERE seats_occupied EQ ALL( SELECT FROM /dmo/flight
*                              FIELDS MAX( seats_occupied )
*                              WHERE currency_code EQ 'EUR' )
*    INTO TABLE @DATA(lt_flight_conn).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_flight_conn ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*   "SUBQUERY ANY/SOME

*    SELECT FROM /dmo/flight
*    FIELDS connection_id
*    WHERE seats_max GT ANY ( SELECT FROM /dmo/flight
*                             FIELDS seats_max
*                             WHERE carrier_id EQ 'AA'  )
*    INTO TABLE @DATA(lt_flight_seatmax).
*
*    IF sy-subrc EQ 0.
*      out->write( |Cantidad de vuelos: { lines( lt_flight_seatmax ) } | ).
*      out->write( lt_flight_seatmax ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*   "SUBQUERY EXISTS

*    SELECT FROM /dmo/carrier AS carrier
*    FIELDS *
*    WHERE carrier_id EQ ANY ( SELECT FROM /dmo/flight AS flight
*                              FIELDS carrier_id
*                              WHERE carrier_id EQ carrier~carrier_id )
*    INTO TABLE @DATA(lt_exist).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_exist ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*   "SUBQUERY IN

*    SELECT FROM /dmo/flight
*    FIELDS connection_id
*    WHERE carrier_id IN ( 'AA', 'DL' )
*    INTO TABLE @DATA(lt_connetionid).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_connetionid ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*   "INNER JOIN

*    SELECT FROM /dmo/flight AS flight
*    INNER JOIN /dmo/carrier AS carrier ON flight~carrier_id EQ carrier~carrier_id
*    FIELDS flight~connection_id,
*           flight~flight_date,
*           carrier~name AS AirportName
*    INTO TABLE @DATA(lt_inner).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_inner ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*   "LEFT OUTER JOIN

*    SELECT FROM /dmo/flight AS flight2
*    LEFT JOIN /dmo/carrier AS carrier2 ON flight2~carrier_id EQ carrier2~carrier_id
*    FIELDS connection_id,
*           flight_date,
*           name AS AirportName
*    INTO TABLE @DATA(lt_left_join).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_left_join ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*   "RIGHT OUTER JOIN
*
*    SELECT FROM /dmo/flight AS flight3
*    RIGHT JOIN /dmo/carrier AS carrier3 ON flight3~carrier_id EQ carrier3~carrier_id
*    FIELDS connection_id,
*           flight_date,
*           name AS AirportName
*    INTO TABLE @DATA(lt_RIGHT_join).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_RIGHT_join ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*   "LEFT / RIGHT EXCLUDING INNER JOIN

*    SELECT FROM /dmo/flight AS flight_l
*    FIELDS connection_id,
*           flight_date
*    WHERE carrier_id NOT IN ( SELECT FROM /dmo/carrier AS carrier_l
*                              FIELDS carrier_l~carrier_id
*                              WHERE carrier_l~carrier_id EQ flight_l~carrier_id )
*    INTO TABLE @DATA(lt_left_excl).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_left_excl ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*   "CROSS JOIN

    SELECT FROM /dmo/flight AS flight
    CROSS JOIN /dmo/carrier AS carrier
    FIELDS flight~connection_id ,
           flight~flight_date,
           carrier~name
           INTO TABLE @DATA(lt_cross).

    IF sy-subrc EQ 0.
      out->write( lt_cross ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.


  ENDMETHOD.
ENDCLASS.
