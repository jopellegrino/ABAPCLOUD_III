CLASS zcl_6_query_dinamic_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_6_query_dinamic_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""FILTROS CON WHERE DINAMICOS EN UNA QUERY


    TYPES: BEGIN OF ty_content_2,
             AirlineId          TYPE /dmo/carrier_id,
             connectionid       TYPE /dmo/connection_id,
             FlightDate         TYPE /dmo/Flight_Date,
             CurrencyCode       TYPE /dmo/currency_code,
             Price              TYPE /dmo/flight_price,
             DepartureAirport   TYPE /dmo/airport_from_id,
             DestinationAirport TYPE /dmo/airport_to_id,
           END OF ty_content_2.

    DATA: lt_content_2         TYPE STANDARD TABLE OF ty_content_2,     "ITAB USADA EN EL SELECT
          lv_datasource_name_2 TYPE string,                             "VAR PARA LA FUENTE DE DATOS DINAMICA
          lv_selected_colums   TYPE string,                             "VAR PARA LAS COLUMNAS DINAMICAS
          lv_where_conditions  TYPE string,                             "VAR PARA LAS CONDICIONES WHERE DINAMICAS
          lv_airline_id        TYPE string.                             "OTRO DATO VARIABLE PARA CONDICION

    DATA lx_dynamic_osql_2 TYPE REF TO cx_root.

    lv_datasource_name_2 = '/DMO/I_Connection'.     "ASIGNACION DEL AFUENTE DINAMICA /DMO/I_FLIGHT O "/DMO/I_Connection



    IF lv_datasource_name_2 EQ '/DMO/I_Connection'.                                             "ASIGNACIONES DEPENDIENDO DE LA CONDICION

      lv_selected_colums = |AirlineId, ConnectionID, DepartureAirport, DestinationAirport|.     "ASIGNACION DINAMICA DE LOS CAMPOS, DEPENDIENDO DE LA FUENTE
      lv_where_conditions = |AirlineId eq 'LH' OR AirlineId EQ 'AA'|.                           "ASIGNACION  DE FILTROS DEL WHERE DINAMICOS
      lv_airline_id = 'AA'.

    ELSEIF lv_datasource_name_2 EQ '/DMO/I_FLIGHT'.

      lv_selected_colums = |AirlineID, ConnectionID, FlightDate, Price, CurrencyCode|.          "ASIGNACION DINAMICA DE LOS CAMPOS
      lv_where_conditions = |( AirlineId eq 'LH' OR AirlineId EQ 'lv_airline_i '{ lv_airline_id }' ) AND CurrencyCode EQ 'USD'|.            "FILTROS DEL WHERE DINAMICOS, Y TAMBIEN UNA CONDICION EXTRA APARTE
      lv_airline_id = 'LH'.

    ENDIF.



    TRY.
        SELECT FROM (lv_datasource_name_2)
        FIELDS (lv_selected_colums)
        WHERE (lv_where_conditions)                         "SE COLOCA LA VARIABLE DINAMICA DEL WHERE
        INTO CORRESPONDING FIELDS OF TABLE @lt_content_2.

      CATCH cx_sy_dynamic_osql_syntax
            cx_sy_dynamic_osql_semantics
            cx_sy_dynamic_osql_error INTO lx_dynamic_osql_2.
        out->write( lx_dynamic_osql_2->get_text(  ) ).
        RETURN.
    ENDTRY.

    IF sy-subrc = 0.
      out->write( lines( lt_content_2 ) ).              "IMPRIME LA CANTIDAD DE LINEAS DE LA ITAB TRAIDAS DE LA BBDD
      out->write( lt_content_2 ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.




  ENDMETHOD.
ENDCLASS.
