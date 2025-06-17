CLASS zcl_lecturas_03_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lecturas_03_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""SELECT/ENDSELECT (ES COMO UNA ITERACION EN LA CAPA ABAP) (NO RECOMENDABLE YA QUE ITERA REGISTRO POR REGISTRO, OSEA MULTIPLES OPERACIONES BBDD<->ABAP)

    out->write( |"""""SELECT/ENDSELECT"""""| ).

    DATA lt_flight TYPE STANDARD TABLE OF zflight_joh.

    SELECT FROM zflight_joh
         FIELDS *
         WHERE currency_code = 'USD'
         INTO @DATA(ls_flights).              "AL USAR UNA STRUC.

      IF ls_flights-plane_type = '767-200'.   "ESTO ESTA DENTRO DEL BUCLE SELECT Y LO APLICA PARA CADA CAMPO ITERADO
        ls_flights-price      *= '1.10'.           "10% MAS DE SU PRECIO ANTERIOR
      ENDIF.

      APPEND lS_flights TO lt_flight.            "INSERTA LA STRUC. ITERADA DENTRO DE LA ITAB DECLARADA ARRIBA UNA A UNA

    ENDSELECT.

    IF sy-subrc = 0.
      out->write( lt_flight ).                    "IMPRIME LA ITAB. CON LOS PRICE AUMENTADOS
    ENDIF.

    out->write( | | ).


*   """""SELECT PACKAGE SIZE (CONTROLA EL NUMERO DE PAQUETES ROWS DE SELECT ENDSELECT

    out->write( |"""""SELECT PACKAGE SIZE"""""| ).

    DATA lt_flight_02 TYPE SORTED TABLE OF zflight_joh
                      WITH NON-UNIQUE KEY airline_id connection_id flight_date.

    SELECT FROM zflight_joh
           FIELDS *
           INTO TABLE @lt_flight_02     "POR LO QUE DICE ABAJO SE USA UNA ITAB EN VEZ DE UNA STRUC PARA LAS ITERACIONES
           PACKAGE SIZE 3.              "CADA ITERACION SE HARA POR PAQUETES DE 3, OSEA 3 REGISTROS EN CADA ITERACION

      LOOP AT lt_flight_02 ASSIGNING FIELD-SYMBOL(<ls_flights>).

        out->write( | { <ls_flights>-airline_id } { <ls_flights>-connection_id }| ).   "IMPRIME EL BATCH DE PAQUETES DE 3 ROWS

      ENDLOOP.

      out->write( | | ).

    ENDSELECT.



*    """""SELECT NO RECOMENDABLES O NO POSIBLES EN ABAP CLOUD

    "NO VALIDAD EN ESTA VERSION

*    SELECT SINGLE FOR UPDATE   "SELECIONA UN REGISTRO Y LO BLOQUEA PARA LA ACTUALIZACION Y NADIE PUEDE USARLO
*    FROM zflight_joh
*    FIELDS *
*    INTO @DATA(ls_dummy).


*    SELECT SINGLE FROM zflight_joh USING CLIENT '200' INTENTA USAR OTRO MANDANTE, QUE NO ES EL QUE TIENE EL USARIO QUE LO INTENTA
*    FIELDS *
*    INTO @DATA(ls_dummy_02).

    "POSIBLE DE USAR PERO NO RECOMENDADO

    SELECT FROM /dmo/i_flight
    FIELDS *
    FOR ALL ENTRIES IN @lt_flight_02
    WHERE AirlineId = @lt_flight_02-airline_id
    INTO TABLE @DATA(lt_dummy).



  ENDMETHOD.
ENDCLASS.
