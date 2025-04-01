CLASS zcl_23_itab3_del_cle DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_23_itab3_del_cle IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*   """""""""DELETE (BORRAR UN REGISTRO ENTERO DE UNA ITAB USANDO UN CAMPO)

    DATA: gt_flight_struc TYPE STANDARD TABLE OF /dmo/airport,
          gs_flight_struc TYPE /dmo/airport.

    SELECT FROM /dmo/airport
    FIELDS *
    WHERE country = 'US'
    INTO TABLE @gt_flight_struc.



    IF sy-subrc = 0.                                        "SE RECOMIENDA HACER CUANDO SE HACE ALGUNA OPERACION EN BBDD

      out->write( data = gt_flight_struc name = 'BEFORE GT_FLIGHT_STRUC' ).

      LOOP AT gt_flight_struc INTO gs_flight_struc.         "RECORRE LA TABLA USANDO LA WA, BUSCANDO LOS REGISTROS QUE QUIERO ELIMINAR

        IF gs_flight_struc-airport_id = 'JFK' OR            "COMPRUEBA LOS REGISTROS DE LA TABLA QUE QUIERES QUE SEAN ELIMINADOS
           gs_flight_struc-airport_id = 'BNA' OR
           gs_flight_struc-airport_id = 'BOS'.

          DELETE TABLE gt_flight_struc FROM gs_flight_struc.  "ESTRUCTURA LA TABLA CUAL QUIERES ELIMINAR REGISTROS Y LUEGO LOS REGISTROS DE LA STRU DE DONDE SE ELIMAN

        ENDIF.
      ENDLOOP.

*   """"""""DELETE (BORRAR UN REGISTRO DE UNA ITAB USANDO UN INDEX
      DELETE gt_flight_struc INDEX 2.    "DENTRO DE LA VERIFICACION SY-SUBRC


*   """"""""DELETE (BORRAR RANGO DE REGISTROS DE UNA ITAB USANDO UN INDEX)
      DELETE gt_flight_struc FROM 5 TO 8.


*   """"""""DELETE (BORRA UN CAMPO VACIO DENTRO DE LA ITAB)
      DELETE gt_flight_struc WHERE city IS INITIAL.


*   """"""""DELETE (BORRAR LOS REGISTROS DONDE HAY CAMPOS REPETIDOS Y SOLO DEJA UNO)
      DELETE ADJACENT DUPLICATES FROM gt_flight_struc COMPARING country. "DEBES COLOCAR EL CAMPO


    ENDIF.

    out->write( data = gt_flight_struc name = 'AFTER GT_FLIGHT_STRUC' ).
    out->write( | | ).


*    """""""CLEAR / FREE (BORRAR DATOS DE UNA ITAB) (PARA GESTIONAR MEMORIA DE UNA ITAB)(VISUALMENTE NO HAY DIFERENCIA)

    IF sy-subrc = 0. "TODO DENTRO DE LA COMPROVACION

      "SENTENCIA CLEAR BORRAR O INICIALIZAR EL CONTENIDO DE UNA ITAB (VACIA EL CONTENIDO DE ITAB PERO NO LIBERA LA MEMORIA CUANDO PRETENDES VOLVER A USAR LA TABLA)
      CLEAR gt_flight_struc.
      out->write( data = gt_flight_struc name = 'CLEAR GT_FLIGHT_STRUC' ).
      out->write( | | ).


      "SENTENCIA FREE (BORRAR TODO Y LIBERA LA MEMORIA ASIGNADA A LA ITAB, YA NO NECESITAS LA TABLA Y DESEAS LIBERAR LA MEMORIA)
      FREE gt_flight_struc.
      out->write( data = gt_flight_struc name = 'FREE GT_FLIGHT_STRUC' ).
      out->write( | | ).


      "OTRA FORMA
      gt_flight_struc = VALUE #( ).
      out->write( data = gt_flight_struc name = 'VALUE GT_FLIGHT_STRUC' ).
      out->write( | | ).

    ENDIF.


*    """""""""SETENCIA COLLECT (INSERTA EL CONTENIDO DE UNA STRUC. CON LA MISMA PRIMARY KEY A UNA TABLA) (NO USAR EN TABLAS STANDAR OBSOLETO)(DEBEN TENER PRI CLAVE UNICA Y LLENA EN EL ORDEN DE LA KEY)

    DATA: BEGIN OF ls_seats,                                "ESTRUCUTRA YA CON MEMORIA ASIGNADA
            carrier_id TYPE /dmo/flight-carrier_id,
            connid     TYPE /dmo/flight-connection_id,
            seats      TYPE /dmo/flight-seats_max,
            price      TYPE /dmo/flight-price,
          END OF ls_seats.


    DATA gt_seats LIKE HASHED TABLE OF ls_seats WITH UNIQUE KEY carrier_id connid.  "USA LIKE YA QUE HACE REFERENCIA A UNA VARIABLE YA DECLARADA Y NO UNA STRUC.

    SELECT carrier_id, connection_id, seats_max, price   "SOLO TRAIGO ESTOS REGISTROS DE DMO/FLIGHT
    FROM /dmo/flight
    INTO @ls_seats.

      COLLECT ls_seats INTO gt_seats. "LUEGO DE GUARDAR EN LA STRUC, SE VOLCAN EN LA TABLA, EN CADA LOOP

    ENDSELECT. "SELECT-ENDSELECT ES COMO APLICAR UN LOOP SOBRE LA LECTURA DE BBDD, Y POR CADA ITER SE GUARDA CADA UNO DE LOS REGISTROS SOBRE ESTRUCT

    out->write( data = gt_seats name = 'COLLECT GT_SEATS' ).
    out->write( | | ).


*   """""""""OPERACION LET (DEFINE VARIABLES O SIMBOLOS DE CAMPO AUX Y LES ASIGNA LOS VALORES, EVITA DECLARA VAR AUXILIARES)
    "(SOBRE LA ITAB)(SOLO SE PUEDE USAR EN OPERADORES CONSTRUCTURES)
    SELECT FROM /dmo/flight
    FIELDS *
    WHERE currency_code = 'USD'
    INTO TABLE @DATA(lt_flights).

    SELECT FROM /dmo/BOOKING_M
    FIELDS *
    INTO TABLE @DATA(lt_airline)
    UP TO 50 ROWS.
*                                                                                                                          "EL CAMPO CARRIER_ID SEA IGUAL TANTO EN LA ITAB LT_FLIGHT, COMO EN LA STRUC QUE SE ESTA ITERANDO
    LOOP AT lt_flights INTO DATA(ls_flight_let).
*                                                                                                             "ESTO ME TRAE EL CAMPO TRAVEL_ID DEL REGISTRO EN DONDE AMBAS TABLAS TIENEN EL MISMO CARRIER_ID SI NO COLOCAS -TRAVEL_ID TRAERIA TODO EL REGISTRO
      DATA(lv_flight) = CONV string( LET lv_airline = lt_airline[ carrier_id = ls_flight_let-carrier_id ]-travel_id        "LO QUE VA DESPUES DEL = CORRESPONDE A UN READ TABLE, POR ESO TRAES LA ITAB
                                         lv_carrid = lt_airline[ carrier_id = ls_flight_let-carrier_id ]-carrier_id        "TIENE MILES DE REGISTROS  "DECL UNA VAR DONDE SE GUARDARA TODO Y QUIERO QUE SEA TIPO STRING

                                         lv_flight_price = lt_flights[ carrier_id = ls_flight_let-carrier_id
                                                                       connection_id = ls_flight_let-connection_id ]-price   "HACER UNA COMPARACION CON LA MISMA TABLA QUE ESTAS RECORRIENDO NO TIENE SENTIDO, COMO ARRIBA

                                        lv_bebesita = ls_flight_let-price

                                       IN | Travel_id: { lv_airline } / Price: { lv_flight_price } / Price (BEBESITA): { lv_bebesita } / CARRIER_ID: { lv_carrid } | ).
      out->write( data = lv_flight ).

    ENDLOOP.










  ENDMETHOD.
ENDCLASS.
