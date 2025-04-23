CLASS zcl_02_exp_constr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_02_exp_constr IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""OPERADOR CONV (PARA REALIZAR CONVERSIONES EXPLICITAS DE TIPOS DE DATOS CONTROLADA)

    out->write( |"""""OPERADOR CONSTRUCTOR CONV"""""| ). "CONVERTIR UN I A STRING, Y ASIGNARLO A UNA VAR TIPO STRING

    DATA: lv_int    TYPE i VALUE 123,
          lv_string TYPE string.

    lv_string = CONV string( lv_int ).

    out->write( lv_string ).
    out->write( | | ).


*    """""CONV PARA ITAB (VOLCAR LA INFO DE UN TIPO DE ITAB A OTRO, CONVERTIENDO LA ITAB(SORT) EN OTRO TIPO DE ITAB(STAND)
    out->write( |"""""CONV (TIPOS DE TABLAS)"""""| ).

    TYPES lt_type TYPE TABLE OF i WITH EMPTY KEY.                    "DECLARACION DE UN TIPO DE ITAB(STAND), CON CLAVE VACIA

    DATA lt_itab TYPE SORTED TABLE OF i WITH NON-UNIQUE DEFAULT KEY. "DECLARACION DE ITAB DE TIPO I(SORT), POR DEFECTO PORQUE SOLO TIENE UNA COLUMNA

    lt_itab = VALUE #( ( 1 ) ( 2 ) ( 3 ) ( 4 ) ).

    DATA(lt_conv) = CONV lt_type( lt_itab ).

    out->write( lt_conv ).
    out->write( | | ).


*    """""EXACT (CONVERSIONES DE TIPOS DE DATOS CON UNA VERIFICACION ESTRICTA)(GARANTIZA QUE LA CONVERSIONES SE REALIZA SOLO SI SE PUEDE REALIZAR EXACTAMENTE EN EL TIPO DESTINO SI NO DA ERROR)
    out->write( |"""""EXACT"""""| ).

    """"""INT->INT2

    DATA: lv_int_value  TYPE i VALUE 32767,                               "UNA COVERSION QUE MATIENE LA INTEGRIDAD DEL VALOR, SI NO SALTA UN ERROR
          lv_int2_value TYPE int2.

    TRY.
        lv_int2_value = EXACT int2( lv_int_value ).                       "INT -> INT2BYTES(LEN5), SI LO CAMBIAS A INT1 DARIA ERROR PORQUE NO CABE TODO EL NUMERO

        out->write( data = lv_int2_value name = 'Valor convertido (INT->INT2)' ).

      CATCH cx_sy_conversion_error INTO DATA(lx_error).                   "ES RECOMENDADO CAPTURAR LA POSIBLE EXCEPCION

        out->write( data = lx_error->get_longtext(  ) name = 'Error' ).   "MENSAJE AL USER DEL ERROR, ADD EL ->get_longtext(  ) MUESTRA EL TEXTO LARGO AL USER
    ENDTRY.
    out->write( | | ).


    """"""CARACTER -> INT  (AL TENER DECIMALES NO PUEDE HACER LA CONV EXACTA)

    DATA: lv_TEXT_value   TYPE string VALUE '327.67',
          lv_int_value_03 TYPE i.

    TRY.
        lv_int_value_03 = EXACT i( lv_TEXT_value ).

        out->write( data = lv_int_value_03 name = 'Valor convertido (CARACTER -> NUM)' ).

      CATCH cx_sy_conversion_error INTO DATA(lx_error2).

        out->write( data = lx_error2->get_text(  ) name = 'Error' ).
    ENDTRY.
    out->write( | | ).



*   """""OPERADOR CONSTRUCTOR REF""""" (CREA UNA REFERENCIA A UN OBJETO O ESTRUCTURAS)(PUNTEROS)
    out->write( |"""""REF""""" | ).

    DATA: lv_int_02  TYPE i VALUE 100,
          lv_ref_int TYPE REF TO i.

    lv_ref_int = REF #( lv_int_02 ).        "APUNTA AL ESPACIO EN MEMORIA DE lv_int_02, SI FUERA DECL EN LINEA DEBES COLOCAR EL TIPO

    out->write( data = lv_int_02 name = 'VALOR ORIGINAL' ).
    out->write( data = lv_ref_int name = 'LV_REF_INT' ).
    out->write( | | ).


    """""REF ITAB""""" REFRENCIA A TABLAS INTERNAS O INDICES

    DATA lt_flight TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY.

    SELECT FROM /dmo/flight
    FIELDS *
    INTO TABLE @lt_flight
    UP TO 3 ROWS.

    DATA(lr_flight) = REF #( lt_flighT[ 2 ] ).                      "ASIGNE REFERENCIA AL INDICE 2 DE LA TABLA
    out->write( data = lr_flight->* name = 'Reference Index 2'  ).  "SE IMPRIME LA REFERENCIA Y ESTA APUNTA AL ESPACIO ASIGNADO

    DATA(lr_flight_02) = REF #( lt_flighT[ 6 ] OPTIONAL ).          "APUNTAMOS A UN INDEX QUE NO EXISTE, PARA EVITAR EL ERROR MUESTRA OPCIONAL (VACIO)
    out->write( data = lr_flight_02 name = 'Reference Index 6'  ).  "NO ES NECESARIO COLOCAR ->*, EN VEZ DE COLOCAR OPCIONAL PUEDES COLOCAR DEFAULT, Y SE COLOCA UN INDEX QUE QUIERAS
    out->write( | | ).

    """""REFERENCIA A OBJETOS DE CLASES O INSTANCIAS DE CLASE

    DATA(lor_emp_01) = NEW zcl_01_exp_constr( iv_age = 22 iv_name = 'Sol' ). "CREACION DE LA INSTANCIA DE CLASE, SE INICIALIZAN LOS PARAMETROS DE IMPORTACION

    DATA(lor_emp_02) = REF #( lor_emp_01 ).                                  "LUEGO SE HACE LA REFERENCIA AL OBJETO QUE ESTA INICIALIZADO, APUNTADO A ESA INSTANCIA DE CLASE

    out->write( data = lor_emp_02 name = 'Object Reference' ).               "SE IMPRIME LA REFENCIA QUE APUNTA AL OBJETO
    out->write( | | ).


*    """""CAST"""""(CONVERTIR TIPOS DE DATOS O CLASES DE FORMA EXPLICITA, GARANTIZANDO LA CONVERSION CORRECTA)
    "DOWN CASTING CONVERSION DE UNA REFERENCIA A CLASE BASE A UNA REF CLASE DERIVADA
    out->write( | """""CAST"""""| ).

    TYPES: BEGIN OF t_struc,
             col1 TYPE i,
             col2 TYPE i,
           END OF t_struc.

    DATA: lr_data TYPE REF TO data,    "VAR DE REF. DE TIPO GENERICO
          Ls_int  TYPE t_struc.    "LOCAL STRUC.

    lr_data = NEW t_struc(  ).         "INSTANCIA DEL OBJETO DE REFERENCIA A DATA

    Ls_int = CAST t_struc( lr_data )->*. "ACCESO TODO COMPLETO / CONVERTIR DE TIPO DATA A TIPO T_STRUC Y VOLCARLOS EN UNA STRUC TIPO T_STRYC, ->* NAVEGAR SOBRE TODA LA INFO *

    Ls_int-col1 = CAST t_struc( lr_data )->col1. "ESTO ACCESO UNO A UNO
    Ls_int-col2 = CAST t_struc( lr_data )->col2.

    out->write( data = Ls_int name = 'LS_INT' ).  "SOLO TRAE CEROS PORQUE SOLO SE HA INICIALIZADO

    out->write( data = Ls_int-col1 name = 'LS_INT-COL1' ). "TREYENDO DE UNO A UNO
    out->write( data = Ls_int-col2 name = 'LS_INT-COL2' ).

    "ESTO DA LA MISMA OPERACION

    CAST t_struc( lr_data )->* = ls_int. "ACCESO COMPLETO
    out->write( data = Ls_int name = 'LS_INT' ).
    out->write( | | ).


*    """""FILTER""""" (FILTRAR ENTRADAS DE UNA ITAB, CON UNA CONDIC. Y VOLCARLA EN OTRA ITAB)(SE PUEDE USAR UNA TABLA DE RANGOS EN LA COND.)
    "LA TABLA EN QUE USA EL FILTER DEBE TENER UNA CLAVE SORT(CUALQUIER COMPARADOR) O HASH(SOLO =) Y AND

    out->write( | """""FILTER"""""| ). "SE OBTIENE UNA ITAB CON TRES CAMPOS ESPECIFICOS A PARTIR DE OTRA TABLA

    DATA: lt_flight_all   TYPE STANDARD TABLE OF /dmo/flight, "DATA(TABLA_RESULT) = FILTER #(FROM "ITAB FUENTE" WHERE "CONDIC")
          lt_flight_final TYPE STANDARD TABLE OF /dmo/flight,
          "FILTER TABLE
          lt_filter       TYPE SORTED TABLE OF /dmo/flight-carrier_id WITH UNIQUE KEY table_line. "CLAVE DE LA UNICA DEL UNICO COMPONENTE, TABLE LINE TODA LA FILA DE LA ITAB SE INTERPRETA COMO UN SOLO COMPONENTE

    SELECT FROM /dmo/flight
    FIELDS *
    INTO TABLE @lt_flight_all.

    lt_filter = VALUE #( ( 'LH ' ) ( 'AA ' ) ( 'UA ' ) ). "ESTO SE USARA COMO FILTRO, PARECIDO A UNA TABLA DE RANGOS, ESO SIGNIFICA QUE ESOS TRES CAMPOS SERAN LAS COMPARACIONES

    lt_flight_final = FILTER #( lt_flight_all IN lt_filter WHERE carrier_id = table_line ).
*   TABLA QUE RECIBE TODO --- DE DONDE SE SACAN LOS DATOS "IN" DONDE SE TOMAN LAS CONDICIONES (TABLA DE FILTRO) "WHERE" CARRIER_ID (lt_flight_all) = A LA CLAVE UNICA DE LA ITAB DE FILTRO (lt_filter)

    out->write( data = lt_flight_all name = 'Tabla de Origen' ).
    out->write( data = lt_flight_final name = 'Tabla Final' ).

  ENDMETHOD.

ENDCLASS.
