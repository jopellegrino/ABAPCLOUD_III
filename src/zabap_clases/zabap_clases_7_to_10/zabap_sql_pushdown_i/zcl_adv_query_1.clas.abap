CLASS zcl_adv_query_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_ADV_QUERY_1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*   """"""DECLARACION EN LINEA

    SELECT *
    FROM /DMO/I_Customer
    INTO TABLE @DATA(lt_customers)
    UP TO 10 ROWS.

    IF sy-subrc EQ 0.
      out->write( lt_customers ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( cl_abap_char_utilities=>newline ).


*   """"""ESPECIFICACION DE COLUMNAS

    SELECT FROM /DMO/I_Customer
    FIELDS CustomerID,
           FirstName,
           PhoneNumber,
           EMailAddress
    INTO TABLE  @DATA(lt_customers_2)
    UP TO 10 ROWS.

    out->write( cl_abap_char_utilities=>newline ). "LINEA EN BLANCO


*   """""VARIABLES DE HOST (VARIABLES DEL CONTEXTO A LAS QUE SE PUEDE ACCEDER)

    DATA lv_airline_id TYPE c LENGTH 3 VALUE 'LH'.

    TYPES: BEGIN OF ty_result,
             airlineid    TYPE c LENGTH 3,
             ConnectionID TYPE c LENGTH 4,
             availability TYPE c LENGTH 1,
           END OF ty_result.

    DATA ls_result TYPE ty_result.

    SELECT SINGLE FROM /DMO/I_Flight
    FIELDS AirlineID,
           ConnectionID
    WHERE AirlineID EQ @lv_airline_id
    INTO CORRESPONDING FIELDS OF @ls_result.

    IF sy-subrc EQ 0.
      out->write( ls_result ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( cl_abap_char_utilities=>newline ).


    """""USANDO UN PUNTERO,Y TAMBIEN UNA VAR O CTTE COLONCANDOLA COMO UN CAMPO, A PESAR DE NO VENIR DE UNA ITAB

    ASSIGN ls_result TO FIELD-SYMBOL(<fs_results>).     "PUNTERO
    CONSTANTS lc_inmediately TYPE c LENGTH 1 VALUE 'I'. "VARIABLE, CTTE


    SELECT SINGLE FROM /DMO/I_Flight
   FIELDS AirlineID,
          ConnectionID,
          @lc_inmediately AS availability
   WHERE AirlineID EQ @lv_airline_id
   INTO CORRESPONDING FIELDS OF @<fs_results>.

    IF sy-subrc EQ 0.
      out->write( <fs_results> ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( cl_abap_char_utilities=>newline ).


*   """""SECUENCIA DE CLAUSULAS (CALCULANDO EL # DE HACIENTOS DISPONIBLES >= 30 Y TRAE ESOS REGISTROS)
    "FROM
    "FIELDS
    "WHERE
    "GROUP BY
    "ORDER BY
    "INTO
    "UP TO

    CONSTANTS lc_avail_seats TYPE int4 VALUE 30.

    SELECT FROM /DMO/I_Flight
    FIELDS AirlineID,
           ConnectionID
      WHERE ( MaximumSeats - OccupiedSeats ) GE @lc_avail_seats
      GROUP BY AirlineID, ConnectionID
      ORDER BY AirlineID DESCENDING
    INTO TABLE @DATA(lt_results_03)
    UP TO 30 ROWS.

    IF sy-subrc EQ 0.
      out->write( lt_results_03 ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.








  ENDMETHOD.
ENDCLASS.
