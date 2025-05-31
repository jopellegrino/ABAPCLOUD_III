CLASS zcl_19_itab1_corresponding DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_19_ITAB1_CORRESPONDING IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    """""""""""CORRESPONDING (COPIAR DATOS DE UNA STRUC. A OTRA SI SON EL MISMO TIPO Y NOMBRE)

    TYPES: BEGIN OF lty_flights,

             carrier_id    TYPE /dmo/carrier_id,
             connection_id TYPE /dmo/connection_id,
             flight_date   TYPE /dmo/flight_date,
           END OF lty_flights.

    DATA: gt_my_flights TYPE STANDARD TABLE OF lty_flights, "LT CON UNA STRUCTURE IGUAL A LA LS
          gs_my_flights TYPE lty_flights.

    SELECT FROM /dmo/flight             "TOMA TODA LAS FIELDS BBDD Y LA VOLCA EN GT_FLIGHTS (CON FILTRO EUR)
    FIELDS *
    WHERE currency_code EQ 'EUR'
    INTO TABLE @DATA(gt_flights).

    "MAS ANTIGUA
    MOVE-CORRESPONDING gt_flights TO gt_my_flights.   "VOLCA LOS DATOS EN LA FILDS COMPATIBLES DE UNA EN OTRA STRUCT.

    out->write( data = gt_flights name = 'ESTRUTURA CONTENEDORA (FORMA ANTIGUA)' ).
    out->write( | | ).
    out->write( data = gt_my_flights name = 'TABLA RECEPTORA' ).
    out->write( | | ).
    out->write( | | ).
    CLEAR gt_my_flights.


    "MAS ACTUAL 7.4

    gt_my_flights = CORRESPONDING #( gt_flights ). "IGUAL QUE ARRIBA PERO MAS ACTUAL

    out->write( data = gt_flights name = 'ESTRUTURA CONTENEDORA (FORMA ACTUAL)' ).
    out->write( | | ).
    out->write( data = gt_my_flights name = 'TABLA RECEPTORA' ).
    out->write( | | ).
    out->write( | | ).


    "MANTENIENDO LAS LINEAS ANTERIORES SIN SOBREESCRIBIR
    "(ANTIGUA)

    MOVE-CORRESPONDING gt_flights TO gt_my_flights KEEPING TARGET LINES.

    out->write( data = gt_flights name = 'ESTRUTURA CONTENEDORA (MANTENIENDO REGISTROS ANTERIORES)' ).
    out->write( | | ).
    out->write( data = gt_my_flights name = 'TABLA RECEPTORA' ).
    out->write( | | ).
    out->write( | | ).

    "(ACTUAL)(EN BASE VA LOS DATOS BASES Y AFUERA VA LOS NUEVOS AGREGAR

    gt_my_flights = CORRESPONDING #( BASE ( gt_my_flights ) gt_flights ).

    out->write( data = gt_flights name = 'ESTRUTURA CONTENEDORA (MANTENIENDO REGISTROS ANTERIORES X2)' ).
    out->write( | | ).
    out->write( data = gt_my_flights name = 'TABLA RECEPTORA' ).



*    """"""""""CORRESPONDING CUANDO LOS NOMBRES NO SON IGUALES


    TYPES: BEGIN OF lty_flights_2,           "CAMPOS DIFERENTES A LA TABLA (PROBANDO)
             carrier     TYPE /dmo/carrier_id,
             connection  TYPE /dmo/connection_id,
             flight_date TYPE /dmo/flight_date,
           END OF lty_flights_2.

    DATA: gt_my_flights_2 TYPE STANDARD TABLE OF lty_flights_2,
          gs_my_flights_2 TYPE lty_flights_2.


    gt_my_flights_2 = CORRESPONDING #( gt_flights ). "SOLO VUELCA LOS QUE COINCIDEN

    out->write( data = gt_flights name = 'ESTRUTURA CONTENEDORA' ).
    out->write( | | ).
    out->write( data = gt_my_flights_2 name = 'TABLA RECEPTORA_2' ).
    out->write( | | ).
    out->write( | | ).

    "APLICANDO MAPEO
    gt_my_flights_2 = CORRESPONDING #( gt_flights MAPPING carrier = carrier_id connection = connection_id ). "ASIGNE LOS NOMBRES QUE QUERIA IGUALAR DE UNA TABLA A OTRA

    out->write( data = gt_flights name = 'ESTRUTURA CONTENEDORA (MAPEADO)' ).
    out->write( | | ).
    out->write( data = gt_my_flights_2 name = 'TABLA RECEPTORA_2' ).



  ENDMETHOD.
ENDCLASS.
