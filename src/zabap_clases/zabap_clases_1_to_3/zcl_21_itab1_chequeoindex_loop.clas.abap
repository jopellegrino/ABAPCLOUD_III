CLASS zcl_21_itab1_chequeoindex_loop DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_21_itab1_chequeoindex_loop IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.



    DATA: gt_flights TYPE STANDARD TABLE OF /dmo/flight.

    SELECT FROM /dmo/flight
    FIELDS *
    WHERE carrier_id = 'LH'
    INTO TABLE @gt_flights.

    out->write( data = gt_flights name = 'Tabla Interna' ).
    out->write( | | ).

*  """"""""""CHEQUEO DE REGISTROS EN ITAB DEVUELVE SI EXISTE O NO

    IF sy-subrc = 0. "LA LECTURA MEDIANTE SELECT SE REALIZO SATISFACTORIAMENTE ESTO ES TRUE(SE RECOMIENDO HACER ESTO)

      "FORMA ANTIGUA(CON READ TABLE)
      out->write( 'CHEQUEO DE REGISTRO (READ TABLE)' ).

      READ TABLE gt_flights WITH KEY connection_id =  '0403' TRANSPORTING NO FIELDS. "ESTO PARA TENER LA RESPUESTA SI EXISTE O NO (SIN FIELDS)

      IF sy-subrc = 0.                                          "VERIFICA QUE EL READ TABLE SE REALIZO OKEY
        out->write( 'The flight exists in the database' ).
      ELSE.
        out->write( 'The flight does NOT exists in the database' ).
      ENDIF.
      out->write( | | ).


      "FORMA ACTUAL(FUNCION LINE_EXISTS
      out->write( 'CHEQUEO DE REGISTRO (LINES_EXIST)' ).

      IF line_exists( gt_flights[ connection_id = '043' ]  ).
        out->write( 'The flight exists in the database' ).
      ELSE.
        out->write( 'The flight does NOT exists in the database' ).
      ENDIF.
      out->write( | | ).


*   """"""""""INDICE DE UN REGISTRO (LINE INDEX)"""""""""
      out->write( |INDICE DE UN REGISTRO (SY-TABIX)| ).


      "FORMA ANTIGUA (READ TABLE)
      READ TABLE gt_flights WITH KEY connection_id =  '0403' TRANSPORTING NO FIELDS. "LECUTURA DEL REGISTRO

      DATA(lv_index) = sy-tabix.                    "GUARDA EL INDICE DE UN REGISTRO (EL LEIDO ARRIBA, PRIMERA COINCIDENCIA AL RECORRER LA TABLA)

      out->write( |Indice del registro leido(Antiguo) { lv_index } | ).
      out->write( | | ).


      "FORMA ACTUAL(LINE_INDEX)

      out->write( |INDICE DE UN REGISTRO (LINE_INDEX)| ).

      lv_index = line_index( gt_flights[ connection_id = '0403' ] ).
      out->write( |Indice del registro leido(Actual) { lv_index } | ).
      out->write( | | ).


*      """""""""""LINES (CUANTOS REGISTROS HAY EN UNA ITAB)
      out->write( |CANTIDAD DE REGISTROS EN LA TABLA INTERNA| ).

      DATA(lv_num) = lines( gt_flights ).                               "SE LE PASA EL OBJETO(ITAB) DEVUELVE EL NUMERO
      out->write( |La ITAB gt_flights tiene: { lv_num } registros | ).
      out->write( | | ).

*      """""""""""LOOP AT (RECORRER O ITERAR TODOS LOS REGISTROS DE LA TABLA(Y NO SOLO ACCEDER A UNO SOLO)
      out->write( |ITERACIONES DE LA ITAB| ).

      LOOP AT gt_flights INTO DATA(ls_flight).                          "SE NECESITA UNA WORK AREAS PARA GUARDAR CADA REGISTRO (FILA DENTRO DEL BUCLE)
        out->write( data = ls_flight ).                                 "CADA ITERACION GUARDA EN EL WORKAREAS UN REGISTRO, PASO A PASO Y ASI HASTA CULMINAR LA TABLA
      ENDLOOP.
      out->write( | | ).                                                "USANDO F6 SE VA PASO A PASO EL PROGRAMA, SY-TABIX SIGUE LA SECUENCIA DEL LOOP AUMENTANDO CON EL INDEX DEL LOOP


      "LOOP AT CON RESTRICCIONES
      out->write( |ITERACIONES DE LA ITAB (CON RESTRICCIONES DE CAMPOS)| ).

      LOOP AT gt_flights INTO ls_flight WHERE connection_id = '0401'.     "RETRINGIENDO EL CONTENIDO DE LOS RESULTADOS
        out->write( data = ls_flight ).
      ENDLOOP.
      out->write( | | ).


      """""""""USANDO FILD SYMBOLS
      out->write( |ITERACIONES DE LA ITAB (FIELD-SYMBOLS)| ).

      LOOP AT gt_flights ASSIGNING FIELD-SYMBOL(<lfs_flight>) WHERE connection_id = '0401'. "USANDO APUNTADOR A LA VARIABLE
        out->write( data = <lfs_flight> ).
      ENDLOOP.
      out->write( | | ).


      """""""""ITERANDO UN RANGO DE INDICES
      out->write( |ITERACIONES DE LA ITAB (RANGO DE INDEX)(FIELD-SYMBOLS)| ).

      LOOP AT gt_flights ASSIGNING FIELD-SYMBOL(<lfs_flight2>) FROM 3 TO 8. "USANDO APUNTADOR A LA VARIABLE
        out->write( data = <lfs_flight2> ).
      ENDLOOP.


      """"""""""MODIFICANDO UN CAMPO DE LA TABLA CON EL APUTANDOR
      out->write( |ITERACIONES DE LA ITAB (RANGO DE INDEX)(MODIFICANDO CAMPOS)(FIELD-SYMBOLS)| ).

      LOOP AT gt_flights ASSIGNING FIELD-SYMBOL(<lfs_flight3>) FROM 3 TO 8. "USANDO APUNTADOR A LA VARIABLE
        <lfs_flight3>-currency_code = 'COP'.   "ASINGA UN NUEVO VALOR COP AL RANGO ESTABLECIDO DE CURRENCY_CODE
      ENDLOOP.

      out->write( data = gt_flights name = 'Tabla MODIFICADA DE 3 TO 8 (COP)' ).





    ENDIF.


  ENDMETHOD.
ENDCLASS.
