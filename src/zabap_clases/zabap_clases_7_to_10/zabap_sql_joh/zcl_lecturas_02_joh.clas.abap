CLASS zcl_lecturas_02_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LECTURAS_02_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*  """""SELECT INTO CORRESPONDING FIELDS

    TYPES: BEGIN OF ty_flight,                          "SE HIZO UNA STRUC. PARECIDA A LA TAB DE BBDD ZFLIGHT_JOH
             airline_id    TYPE c LENGTH 3,
             connection_id TYPE n LENGTH 4,
             price         TYPE p LENGTH 16 DECIMALS 2,
             currency_code TYPE c LENGTH 5,
           END OF ty_flight.

    DATA lt_flight TYPE STANDARD TABLE OF ty_flight.    "DECLARACION DE UNA ITAB PARECIDA A ZFLIGHT_JOH.

    SELECT FROM zflight_joh
    FIELDS *
    WHERE airline_id = 'LH'
    INTO CORRESPONDING FIELDS OF TABLE @lt_flight.      "ESTO MAPEA LOS DATOS Y LOS ASIGNA A LOS QUE TIENEN LOS MISMO NOMBRES EN LA BBDD Y LA ITAB

    IF sy-subrc = 0.
      out->write( data = lt_flight name = 'INTO CORRESPONDING FIELDS'  ).
    ENDIF.

    "SIN CORRESPONDING Y CAMPO A CAMPO
    SELECT FROM zflight_joh                             "SI TRAES TODOS LOS NOMBRES SE COLOCARAN EN LA ITAB EN EL ORDEN EN QUE LOS TRAISTES
        FIELDS airline_id,                              "SI OMITES UNO LA ITAB SE LLENARA LOS CAMPOS EN EL ORDEN TRAIDO
               connection_id AS connection_id,          "EL COLOCAR ALIAS HACE QUE SE PUEDAN ASIGNAR LOS CAMPOS DE LA BBDD A LA ITAB SIN EL CORRESPONDING
               price,
              currency_code
        WHERE airline_id = 'LH'
        INTO TABLE @lt_flight.

    out->write( | | ).



*    """""SELECT COLUMNS (SELECT COLUMNA A COLUMNA QUE NECESITAS APLICA PARA TRAER ITABS Y STRUCS.)

    out->write( |"""""SELECT COLUMNS"""""| ).

    SELECT SINGLE FROM zflight_joh      "ME TRAIGO SOLO HA UNA CULUMNA DE UN REGISTRO
        FIELDS price,
               currency_code            "SE TRAE SOLO DOS CAMPOS
         WHERE airline_id = 'AA'
         AND flight_date = '20250324'
         AND connection_id = '0322'
    INTO @DATA(lv_flight_price).        "SE CREA UNA STRUC. DE SOLO DOS CAMPOS

    IF sy-subrc = 0.
      out->write( lv_flight_price ).
    ENDIF.

    out->write( | | ).

*   """""SELECT UP TO n ROWS (TE PERMITE RECIBIR n REGISTROS)

    out->write( |"""""SELECT UP TO n ROWS"""""| ).

    SELECT FROM zflight_joh
    FIELDS *
    WHERE airline_id = 'LH'
    INTO TABLE @DATA(lt_flights)
    UP TO 3 ROWS.                       "LIMITA LA CANTIDAD DEL SELECT

    IF sy-subrc = 0.
      out->write( data = lt_flights ).
    ENDIF.




  ENDMETHOD.
ENDCLASS.
