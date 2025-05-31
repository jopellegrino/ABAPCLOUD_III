CLASS zcl_22_itab2_for_select_etc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_22_ITAB2_FOR_SELECT_ETC IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*    """"""""""FOR (LLENARLA UNA TABLA USANDO LA VARIABLE CONTADOR DEL FOR "Y CONDICIONES WHILE Y UNTIL)

    TYPES: BEGIN OF lty_flights,
             iduser     TYPE /dmo/customer_id,
             aircode    TYPE /dmo/carrier_id,
             flightnum  TYPE /dmo/connection_id,
             key        TYPE land1,
             seat       TYPE /dmo/plane_seats_occupied,
             flightdate TYPE /dmo/flight_date,
           END OF lty_flights.

    DATA: gt_flight_info TYPE TABLE OF lty_flights,
          gt_my_flights  TYPE TABLE OF lty_flights.


    gt_flight_info = VALUE #( FOR i = 1 UNTIL i > 30                               "DEBE LLEVAR UN VALUE CUANDO QUIERES AGREGAR REGISTROS (CREA 30 REGISTROS)
                                 ( iduser    = | { 123456 + i } - USER|            "I ES UN CONTADOR (ES UNA VARIABLE DECLARADA ALLI MISMO SIN DATA()
                                  aircode    = 'LH'
                                  flightnum  = 0001 + i
                                   key       = 'US'
                                  seat       = 0 + i
                                  flightdate = cl_abap_context_info=>get_system_date(  ) + i  )  ).

    gt_my_flights = VALUE #( FOR i = 1 WHILE i <= 20
                               ( iduser    = | { 123456 + i } - USER|
                                aircode    = 'LH'
                                flightnum  = 0001 + i
                                 key       = 'US'
                                seat       = 0 + i
                                flightdate = cl_abap_context_info=>get_system_date(  ) + i  )  ).


    out->write( data = gt_flight_info name = 'GT_FLIGHT_INFO' ).
    out->write( | | ).
    out->write( data = gt_my_flights name = 'GT_MY_FLIGHT' ).

    CLEAR gt_flight_info. "LIMPIO LA TABLA PARA VOLVER A USARLA
    out->write( | | ).



*    """""""""""LLENAR UNA TABLA A PARTIR DE OTRA (SE PUEDE FILTRAR LA INFO)

    gt_flight_info = VALUE #( FOR gs_my_flight IN gt_my_flights                   "LUEGO DEL FOR SE DECLARA UNA STRUCTURA SERA DEL TIPO DE LA TABLA LLENA Y LUEGO LA TABLA QUE YA ESTABA LLENA
                                WHERE ( aircode = 'LH' AND flightnum >= 0012 )    "SE PUEDE AGREGAR FILTROS PARA ELEGIR QUE VAMOS A TOMAR DE LA PRIMERA TABLA
                              ( iduser     = gs_my_flight-iduser                  "SE DEBE HACER REFERENCIA A LA ESTRUCTURA A CADA UNO DE LOS CAMPOS QUE ESTAMOS USANDO, YA QUE LA ESTRUCTURA SE LLENA DE LA TABLA EN CADA ITERACION
                                aircode    = gs_my_flight-aircode
                                flightnum  = gs_my_flight-flightnum
                                key        = gs_my_flight-key
                                seat       = gs_my_flight-seat
                                flightdate = gs_my_flight-flightdate  ) ).

    out->write( data = gt_flight_info name = 'GT_FLIGHT_INFO (LLENADA CON GT_MY_FLIGHT )' ).
    out->write( | | ).


*    """"""""""FOR ANIDADO - CURSOR PARALELO(ES UNA TECNICA PARA MEJORAR EL RENDIMIENTO)(ESTO TIENE UN RENDIMIENTO MALO) LLENAR UNA TABLA A PARTIR DE DOS TABLAS

    TYPES: BEGIN OF lty_flifhts_02,            "DECLARACION DE TIPO LOCAL
             aircode     TYPE /dmo/carrier_id,
             flightnum   TYPE /dmo/connection_id,
             flightdate  TYPE /dmo/flight_date,
             flightprice TYPE /dmo/flight_price,
             currency    TYPE /dmo/currency_code,
           END OF lty_flifhts_02.

    SELECT FROM /dmo/flight               "DECLARACION EN LINEA DE DOS TABLAS DE DATOS, CON LECTURA Y VOLCADA DE INFO
    FIELDS *
    INTO TABLE @DATA(gt_flights_type).

    SELECT FROM /dmo/booking_m
    FIELDS carrier_id, connection_id, flight_price, currency_code    "SOLO TOME 4 CAMPOS QUE NECESITAMOS
    INTO TABLE @DATA(gt_airline)
    UP TO 20 ROWS.                                     "SE REDUJO EL NUMERO DE REGISTROS A 20

    DATA gt_final TYPE SORTED TABLE OF lty_flifhts_02 WITH NON-UNIQUE KEY flightprice.

    gt_final = VALUE #( FOR gs_flight_type IN gt_flights_type WHERE ( carrier_id = 'AA' )                   "TAB3 VACIA, Y SIEMPRE QUE SE USE FOR ANIDADO SE FILTRA CON WHERE
                          FOR gs_airline IN gt_airline WHERE ( carrier_id = gs_flight_type-carrier_id )   "FILTRO ESPECIFICO PARA JUNTAR O ANIDADAR LAS DOS TABLAS,
                                                                                                           "AQUI TOMA SOLO LOS REGISTROS DE LA TAB2 Y LOS ITERA CUANDO LA STRUC DE LA TAB1 SEA EL MISMO VALOR DEL CAMPO CARRIER_ID
                          (   aircode     = gs_flight_type-carrier_id               "INFO DE LA TAB1
                              flightnum   = gs_flight_type-connection_id
                              flightdate  = gs_flight_type-flight_date
                              flightprice = gs_airline-flight_price                 "INFO DE LA TAB2
                              currency    = gs_airline-currency_code )    ).

    out->write( data = gt_final name = 'GT_FINAL (FOR ANIDADO, LLENADO UNA TAB3 CON TAB1 Y TAB2 AMBAS CON UN CAMPO EN COMUN)' ).
    out->write( | | ).



*   """""""""""SELECT (CASO TOMAR DATOS DE UNA TABLA INTERNA EN VEZ DE BBDD Y VOLCAR EN OTRA ESTRUCTURA) (AÑADIR MULTIPLES LINEAS)

    "NOTA: "APPEND CORRESPONDING FIELDS INTO TABLE (AGREGA LOS DATOS AL FINAL SIN ELIMINTAR LOS ANTERIORES)
    "INTO CORRESPONDING FIELD OF TABLE (AGREGA LINEAS Y ELIMINAS LAS ANTERIORES

    DATA: gt_flight TYPE STANDARD TABLE OF /dmo/flight. "EL CREA UNA TABLA ASI CREA UNA CLAVE PRIMARIA STANDAR, EN CAMBIO HACER EL LINEA CREA PRIMARY KEY VACIA

    SELECT FROM /dmo/flight
    FIELDS *                            "EL * TRAE TODAS LAS FIELDS, PUEDES TAMBIEN COLOCAR CAMPOS INDIVIDUALES
    WHERE carrier_id = 'LH'             "FILTRO DE QUE TRAER
    INTO TABLE @gt_flight.


    SELECT carrier_id, connection_id, flight_date   "SELECT SOBRE UNA TABLA INTERNA CAMPOS INDIVIDUALES Y VOLCADO EN OTRA ITAB
    FROM @gt_flight AS gt                           "ASIGNA NOMBRE ALIAS
    INTO TABLE @DATA(gt_flights_copy).

    out->write( data = gt_flights_copy name = 'GT_FLIGHT_COPY' ).
    out->write( | | ).



*    """"""""""SENTENCIA SORT (ORDENAR REGISTRO)(NO TIENE SENTIDO USARLA CON ITAB TIPO SORT)

    SORT gt_flights_copy.                   "ITAB CREADA EN LINEA, SE ORDENA POR PRIMARY KEY O UN CAMPO(PERO DEBES DE EXPRESARLO, EN ESTE CASO LO ORDENA CON UNA PRIMARY KEY VACIA PORQUE NO LA HEMOS ESPECIFICADO
    out->write( data = gt_flights_copy name = 'GT_FLIGHT_COPY (SORT EMPTY KEY)' ).
    out->write( | | ).

    SORT gt_flight DESCENDING.              "ITAB CREADA EXPLICITA ESTA NO ES CLAVE VACIA, ESTA TIENE PRIMARY KEY COMO TODOS LOS COMPONENTES O CAMPOS QUE FORMAN LA CLAVE PRIMARIA
    out->write( data = gt_flight name = 'GT_FLIGHT (SORT PRIMARY KEY)' ). "ORDENADO DE FORMA ASCENDETE, SI COLOCAS DESCENDING LO ORDENA DESENDENTE
    out->write( | | ).

    SORT gt_flights_copy BY flight_date DESCENDING connection_id ASCENDING.    "SI NO QUIERES QUE SE ORDENE POR EL CAMPO PRIMARY KEY, SE DEBE ESPECIFICAR EXPLICITO
    out->write( data = gt_flights_copy name = 'GT_FLIGHT_COPY (SORT KEY EXPLICITA)' ). "ESTA SE ORGANIZA DE FORMA DESC POR FLIGHT DATE Y ASCENDING POR CONNETION_ID
    out->write( | | ).



*   """""""""MODIFY (MODIFICAR REGISTROS SE APLICA SOBRE LA ITAB)(TAMBIEN SE HACE CON READ TABLE Y LOOP AT)

    Out->write( data = gt_flight name = 'GT_FLIGHT (ANTES DE MODIFY)' ).
    out->write( | | ).


    LOOP AT gt_flight INTO DATA(gs_flight).

      IF gs_flight-flight_date > '20250101'.   "ENTRA EN EL IF SI EL CAMPO ES MAYOR A ESA FECHA

        gs_flight-flight_date = cl_abap_context_info=>get_system_date(  ).       "ESTO ASIGNA LA FECHA QUE CUMPLE LA CONDICION ENLA FECHA ACTUAL

        MODIFY gt_flight FROM gs_flight INDEX 2.                                 "ESTE CASO SOLO MODIFICA DIRECTAMENTE EL INDEX 2, Y NO MODIFICA LOS DE LA CONDICION

        MODIFY gt_flight FROM gs_flight TRANSPORTING flight_date.                "(FORMA ANTIGUA) ESTO SI MODIFICA TODOS LOS CAMPOS DE QUE CUMPLEN LA CONDICION.

*        MODIFY gt_flight FROM VALUE #(  connection_id = '111'    "ESTO CAMBIA A ESTOS VALORES TODOS LOS QUE CUMPLEN LA CONDICION DEL IF
*                                        Carrier_id     = 'XX'     "LOS QUE NO LES ESPECIFIQUES EN UN REGISTRO VALOR LOS INICIALIZA EN CERO O BLANCO
*                                        plane_type_id = 'YY'
*                                                            ).

        MODIFY gt_flight FROM VALUE #(  connection_id = '111'    "CUANDO SOLO QUIERES HACER LAS MODIFICACIONES Y MANTENER TODOS LOS DEMAS CAMPOS ANTERIORES DEL REGISTRO
                                Carrier_id     = 'XX'
                                plane_type_id = 'YY'
                                                    ) TRANSPORTING connection_id Carrier_id plane_type_id. "SOLO SE AGREGAN LOS QUE QUIERES QUE SE LES APLIQUE EL CAMBIO

      ENDIF.
    ENDLOOP.

    Out->write( data = gt_flight name = 'GT_FLIGHT (DESPUES DE MODIFY)' ).








  ENDMETHOD.
ENDCLASS.
