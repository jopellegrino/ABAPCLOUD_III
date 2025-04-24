CLASS zcl_03_field_symbols DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_03_field_symbols IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    out->write( |"""""DECLARACION FIELD SYMBOLS"""""| ).

*    """"""CONCEPTO Y DECLARACION

    DATA gv_employee TYPE string.

    FIELD-SYMBOLS <gfs_employee> TYPE string.           "DECLARAR UN APUNTADOR, NO ALMACENA MEMORIA, ES INICIAL Y NO HACE AUN REFERENCIA A NINGUNA AREA DE MEMORIA

    ASSIGN gv_employee TO <gfs_employee>.       "ASIGNAR A UN AREA DE MEMORIA, APUNTA A LA VARIABLE

    <gfs_employee> = 'Maria'.                   "DAR VALOR A TRAVES DEL APUNTADOR A LA VAR.

    out->write( gv_employee ).


*    """"""REGISTROS DE UNA STRUCTURA"""""" (MODIFICAR LOS REGISTROS DE UNA ITAB)

    FIELD-SYMBOLS <gfs_flights> TYPE /dmo/flight.   "DECL. APUNTADOR TIPO UNA STRUCTURA, AUN NO APUNTA

    SELECT FROM /dmo/flight
    FIELDS *
    INTO TABLE @DATA(lt_flight)
    UP TO 4 ROWS.

    LOOP AT lt_flight INTO DATA(gs_FLIGHT).       "CAMBIAR UN CAMPO CON UNA STRUCTURA, PRICE = 100 NO FUNCIONA PORQUE DEBES USAR MODIFY
      gs_FLIGHT-price = 100.
    ENDLOOP.

    out->write( data = lt_flight name = 'Tabla Modificada con Struc' ).


    LOOP AT lt_flight ASSIGNING <gfs_flights>.      "CAMBIAR UN CAMPO CON EL APUNTADOR, SI FUNCIONA YA QUE ESTAS DIRECTAMENTE DENTRO DEL ESPACIO DE MEMORIA DONDE SE GUARDA ESE CAMPO.
      <gfs_flights>-price = 100.
    ENDLOOP.

    out->write( data = lt_flight name = 'Tabla Modificada con Apuntador' ).
    out->write( | | ).


*    """""DECL. EN LINEA DE FIELDS SYMBOLS"""""(USANDO EL EJEMPLO DE ARRIBA)

    "ITAB MODIFICAR REGISTROS"

    LOOP AT lt_flight ASSIGNING FIELD-SYMBOL(<gfs_flights_inline>).   "DECL. EN LINEA Y ASGINACION DEL FIELD SYMBOL
      <gfs_flights_inline>-price = 200.                               "MODIFICANDO PRICE = 200
    ENDLOOP.

    out->write( data = lt_flight name = 'Tabla Modificada (Apuntador enLinea)' ).
    out->write( | | ).

    "VAR (DECL. Y ASIGNACION DEL FIELD SYMBOL A APUNTAR A UNA VARIABLE)"

    DATA lv_var TYPE string.

    ASSIGN lv_var TO FIELD-SYMBOL(<gfs_lv_var>).  "DECLARACION Y ASIGNACION TODO EN LINEA
    <gfs_lv_var> = 'Victor'.                      "DAR VALOR A TRAVES DEL APUNTADOR

    out->write( lv_var ).

    UNASSIGN <gfs_lv_var>.                        "ESTO QUITA LA ASIGNACION A LA VARIABLE
    out->write( |  | ).


*   """""FOR (FIELD SYMBOLS)(COPIA DE DATOS DE UNA ITAB HACIA OTRA ITAB ITERANDO SUS CAMPOS)
    out->write( |"""""FOR-FIELD_SYMBOLS"""""| ).

    DATA gt_flight_for TYPE STANDARD TABLE OF /dmo/flight.

    gt_flight_for = VALUE #( FOR <gfs_flight_for> IN lt_flight     "FOR" APUNTADOR "IN" ITAB DE DONDE VIENE LOS DATOS
                            ( CORRESPONDING #( <gfs_flight_for> ) ) ).  "COLOCA CAMPO A CAMPO QUE APUNTA EL APUNTADOR DENTRO DE LA ESTRCUTURA DE LA TABLA COPIA

    out->write( data = gt_flight_for name = 'FOR (FIELD-SYMBOL)' ).
    out->write( |  | ).


*   """""AÑADIR """"" SIEMPRE A LA ULTIMA POSICION
    out->write( |"""""AÑADIR, INSERTAR Y LEER REGISTROS"""""| ).

    SELECT FROM /dmo/flight
    FIELDS *
    INTO TABLE @DATA(lt_flight_02)
    UP TO 4 ROWS.

    APPEND INITIAL LINE TO lt_flight_02 ASSIGNING FIELD-SYMBOL(<lfs_flight_apd>).    "AGREGA UNA LINEA VACIA Y APUNTA A ESE REGISTRO EL FIELD-SYMBOL, ESTO SE USA PARA ASGINAR EL APUNTADOR

    <lfs_flight_apd> = VALUE #( client         = 666
                                   carrier_id     = 'WW '
                                   connection_id  = 00001
                                   currency_code  = 'BFS'
                                   seats_max      = 666
                                   seats_occupied = 333 ).

    out->write( data = lt_flight_02 name = 'APPEND' ).  "APPEND AÑADE EL REGISTRO AL ULTIMO INDEX DE LA ITAB
    out->write( |  | ).

*   """""INSERT (INSERTAR UN REGISTRO SE AÑADE EN LA POSICION DEPENDIENDO DEL INDICE)

    INSERT INITIAL LINE INTO lt_flight_02 ASSIGNING FIELD-SYMBOL(<lfs_flight_INSR>) INDEX 2.   "LA ADVERTENCIA SOLO PIDE EL INDICE DONDE SE DESEA INSERTAR, SI NO SE COLOCA SE PONE EN EL UNO

    <lfs_flight_INSR> = VALUE #( client         = 888                                       "ESTA ASIGNACION ES AL ESPACIO DE MEMORIA QUE OCUPA EL INDEX 2, ESO SIGNIFICA QUE EL APUNTADOR APUNTA AL INDEX 2
                                carrier_id     = 'SS '
                                connection_id  = 00066
                                currency_code  = 'REAL'
                                seats_max      = 444
                                seats_occupied = 555 ).

    out->write( data = lt_flight_02 name = 'INSERT INDEX 2' ).


*   """""LEER REGISTROS (READ TABLE) Y MODICANDO CAMPOS CON APUNTADORES

    READ TABLE lt_flight_02 ASSIGNING FIELD-SYMBOL(<lfs_flight_read>) WITH KEY carrier_id = 'WW'.   "DECLARADO Y ASGINADO EL FIELD-SYMBOL HACIA EL CAMPO 'WW' SI HAY VARIOS WW SOLO TOMA EL PRIMERO

    <lfs_flight_read>-price = '6666'.
    <lfs_flight_read>-plane_type_id = '666-666'.

    out->write( data = lt_flight_02 name = 'INSERT INDEX 2' ).
    out->write( |  | ).


*   """""CAST (COERCION - CASTEO) (CONVERSIONES CON ESPECIFICACIONES DE MANERA EXPLICITA O IMPLICITA)
    out->write( |"""""CAST""""" | ).

    TYPES: BEGIN OF gty_date,
             year(4)  TYPE n,
             month(2) TYPE n,
             day(2)   TYPE n,
           END OF gty_date.

    FIELD-SYMBOLS: <lfs_date>    TYPE gty_date,         "CREACION DE APUNTADOR, MAS NO ESTA ASIGNADO A NINGUN ESPACIO DE MEMORIA
                   <lfs_date_02> TYPE any,              "TIPO GENERICO, NECESITA UN CASTEO EXPLICITO
                   <lfs_date_03> TYPE n.


    DATA(lv_data) = cl_abap_context_info=>get_system_date( ).

    ASSIGN lv_data TO <lfs_date> CASTING.               "ASIGNACION DEL APUNTADOR, COMO LOS TIPOS NO SON COMPATIBLES DA ERROR, POR ELLO SEBE DEBE HACER UN CAST, ESTO PERMITE TRATAR A LV_DATE COMO UNA STRUC TY_DATE

    out->write( <lfs_date>-year ).
    out->write( <lfs_date>-month ).
    out->write( <lfs_date>-day ).

    "CASTEO EXPLICITO AL TIPO ANY

    ASSIGN lv_data TO <lfs_date_02> CASTING TYPE gty_date. "EN ESTE CASO EXPLICITAMENTE COLOCAMOS EL TIPO AL QUE QUIERO QUE SE CONVIERTA

    "out->write( <lfs_date_02>-year ).          EN ESTE CASO NO TIENE COMPONENTES POR ELLO NO SE PUEDE ACCEDER A CADA CAMPO (NO SE PORQUE xD)


    "FORMA DE PODER VER LOS COMPONENTES ES USANDO UN TERCER APUNTADOR TIPO N
    DO.

      ASSIGN COMPONENT sy-index OF STRUCTURE <lfs_date_02> TO  <lfs_date_03>. "ASIGNA COMPONENTE A COMPONENTE DEL APUNTADOR 2 AL APUNTADOR 3

      IF sy-subrc NE 0. "PARA SALIR DEL BUCLE SI ES DIFERENTE DE CERO ENTONCES SALE, SIGNIFICA QUE ALGO SALIO MAL
        EXIT.
      ENDIF.

      out->write( <lfs_date_03> ).  "Y LUEGO SE IMPRIME ESE COMPONENTE TRAIDO DEL APUNTADOR 2 AL 3

    ENDDO.

  ENDMETHOD.
ENDCLASS.
