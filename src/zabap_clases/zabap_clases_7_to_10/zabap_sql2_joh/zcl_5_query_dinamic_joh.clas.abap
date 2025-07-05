CLASS zcl_5_query_dinamic_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_5_query_dinamic_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*  """""FUENTE DINAMICA (DATA SOURCE DINAMICA DE BBDD) FORMA DE TRAER DATOS DE DIFERENTES FUENTES, CON EL MISMO QUERY CAMBIANDO LA FUENTE CON UNA VARIABLE

    TYPES: BEGIN OF ty_content,                 "TIPO LOCAL QUE TIENE CAMPOS EN COMUN CON /DMO/I_FLIGHT Y /DMO/I_Connection
             AirlineId    TYPE /dmo/carrier_id,
             connectionid TYPE /dmo/connection_id,
           END OF ty_content.

    DATA: lt_content         TYPE STANDARD TABLE OF ty_content,     "UNA ITAB CON CAMPOS EN COMUN ENTRE LAS DOS TABLAS DE BBDD
          lv_datasource_name TYPE string.                           "SE METE LA FUENTE DENTRO DE UNA VAR

    DATA lx_dynamic_osql TYPE REF TO cx_root.               "CX_ROOT ES LA CLASE PADRE DE TODAS LAS EXCEPCIONES, SE PUEDE USAR EN TODOS LOS BLOQUES CATCH

    lv_datasource_name = '/DMO/I_Connection'. "CAMBIABLE /DMO/I_FLIGHT O "/DMO/I_Connection


    TRY.                                                    "ESTE TIPO DE SELECT CON QUERY DINAMICA PUEDE LEVANTAR EXCEPCIONES

        SELECT FROM (lv_datasource_name)                    "SE PASA LA VAR QUE CONTIENE EL NAME DE LA BBDD EN VEZ DE LA TABLA DE BBDD DIRECTAMENTE, Y EL SELECT RECIBE LA FUENTE DE DATOS EN TIEMPO DE EJECUCION
        FIELDS AirlineId, connectionid
        INTO TABLE @lt_content.

      CATCH cx_sy_dynamic_osql_syntax
            cx_sy_dynamic_osql_semantics
            cx_sy_dynamic_osql_error      INTO lx_dynamic_osql.    "SE COLOCAN TODAS LAS EXCEPCIONES
        out->write( lx_dynamic_osql->get_text(  ) ).
        RETURN.                                                    "SI DA ALGUNA EXCEPCION TERMINA TODO, YA QUE NO TIENE SENTIDO CONINUAR EL CODIGO
    ENDTRY.

    IF sy-subrc = 0.
      out->write( lines( lt_content ) ).    "SOLO QUEREMOS VER CUANTOS REGISTROS SE TRAE
      out->write( lt_content ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.



*   """""ESPECIFICACION DINANICA DE COLUMNAS EN UNA QUERY


    TYPES: BEGIN OF ty_content_2,
             AirlineId          TYPE /dmo/carrier_id,
             connectionid       TYPE /dmo/connection_id,
             FlightDate         TYPE /dmo/Flight_Date,
             CurrencyCode       TYPE /dmo/currency_code,
             Price              TYPE /dmo/flight_price,
             DepartureAirport   TYPE /dmo/airport_from_id,
             DestinationAirport TYPE /dmo/airport_to_id,
           END OF ty_content_2.

    DATA: lt_content_2         TYPE STANDARD TABLE OF ty_content_2,
          lv_datasource_name_2 TYPE string,
          lv_selected_colums   TYPE string.                       "VAR NUEVA PARA COLOCAR DINAMICAMENTE LAS COLUMNAS

    DATA lx_dynamic_osql_2 TYPE REF TO cx_root.

    lv_datasource_name_2 = '/DMO/I_FLIGHT'.     "CAMBIABLE /DMO/I_FLIGHT O "/DMO/I_Connection


    IF lv_datasource_name_2 EQ '/DMO/I_Connection'.                                          "CONDICIONES PARA VARIAR LAS COLUMNAS DEL SELECT DEPENDIENDO DE LA FUENTE
      lv_selected_colums = |AirlineId, ConnectionID, DepartureAirport, DestinationAirport|.

    ELSEIF lv_datasource_name_2 EQ '/DMO/I_FLIGHT'.
      lv_selected_colums = |AirlineID, ConnectionID, FlightDate, Price, CurrencyCode|.

    ENDIF.



    TRY.
        SELECT FROM (lv_datasource_name_2)
        FIELDS (lv_selected_colums)                                "SE COLOCA LA VAR DESTINADA COLOCAR DINAMICAMENTE LAS COLUMNAS, QUE FUE MODIFICADA EN EL IF DEPENDIENDO DE LA FUENTE
        INTO CORRESPONDING FIELDS OF TABLE @lt_content_2.          "PARA QUE MAPEE POR EL NOMBRE, EN VEZ POR EL ORDEN

      CATCH cx_sy_dynamic_osql_syntax
            cx_sy_dynamic_osql_semantics
            cx_sy_dynamic_osql_error      INTO lx_dynamic_osql.
        out->write( lx_dynamic_osql_2->get_text(  ) ).
        RETURN.
    ENDTRY.

    IF sy-subrc = 0.
      out->write( lines( lt_content_2 ) ).
      out->write( lt_content_2 ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.





  ENDMETHOD.
ENDCLASS.
