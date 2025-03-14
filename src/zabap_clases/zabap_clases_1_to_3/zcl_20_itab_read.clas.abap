CLASS zcl_20_itab_read DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_20_itab_read IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""""""""READ TABLE (EXISTEN 3 FORMAS: INDICE, CLAVE y OPCION BUSQUEDA POR CLAVE LIBRE)
    out->write( | """"""""""READ TABLE CON INDEX """"""""""| ).
    SELECT FROM /dmo/airport
    FIELDS *
    WHERE country = 'DE'
    INTO TABLE @DATA(lt_flights).

    IF sy-subrc = 0.                                                        "SY-SUBRC LECTURA DE ARRIBA LLEVADA A CABO SIN PROBLEMA
      "IMPRESION DE TABLA ENTERA (READ TABLE)
      out->write( data = lt_flights name = 'Tabla Completa (LT_FLIGHTS)' ).
      out->write( | | ).

      "DEVUELVE UN REGISTRO (READ TABLE)
      READ TABLE lt_flights INTO DATA(ls_flights_aux) INDEX 1.                               "DEVUELVE EL REGISTRO DE UN INDICE O CLAVE
      out->write( data = ls_flights_aux name = 'REGISTRO LEIDO (TODOS LOS CAMPOS)' ).
      out->write( | | ).

      "DEVUELVE REGISTRO DE UN INDICE ESPECIFICO Y CAMPOS ESPECIFICOS (READ TABLE)
      READ TABLE lt_flights INTO DATA(ls_flights_aux2) INDEX 2 TRANSPORTING airport_id city. "DEVUELVE UN REGISTRO ESPECIFICO (CON LOS CAMPOS SELECCIONADOS)
      out->write( data = ls_flights_aux2 name = 'REGISTRO LEIDO (CAMPOS ESPECIFICOS)' ).
      out->write( | | ).

      "DEVUELVE EL REGISTRO CON APUNTADORES (READ TABLE)
      READ TABLE lt_flights ASSIGNING FIELD-SYMBOL(<lfs_flights>) INDEX 3.                  "LOCAL FIELD SYMBOL (APUNTADOR)
      out->write( data = <lfs_flights> name = 'REGISTRO LEIDO (CAMPOS ESPECIFICOS FIELD SYMBOL)' ).
      out->write( | | ).

      "EXPRESIONES DE TABLA (NUEVA SINTAXTIS DE READ TABLE)
      DATA(ls_data) = lt_flights[ 2 ].                                                       "DEVUELVE UNA LS, Y SE COLOCA EL INDICE DENTRO DE LLAVES
      out->write( data = ls_data name = 'REGISTRO LEIDO (INDICE CON EXPRESIONES DE TABLA)' ).
      out->write( | | ).

      DATA(ls_data2) = VALUE #( lt_flights[ 20 ] OPTIONAL ).                                  "SI SIN QUERER COLOCAS UN INDEX QUE NO EXISTE
      out->write( data = ls_data2 name = 'REGISTRO LEIDO (CON INDICE INCORRECTO)' ).          "DEVUELVE UN REGISTRO VACIO
      out->write( | | ).

      DATA(ls_data3) = VALUE #( lt_flights[ 20 ] DEFAULT lt_flights[ 1 ] ).             "SI SIN QUERER COLOCAS UN INDEX QUE NO EXISTE
      out->write( data = ls_data3 name = 'REGISTRO LEIDO (CON INDICE INCORRECTO)' ).    "DEVUELVE UN REGISTRO QUE DESEES PARA NO MOSTRAR VACIO
    ENDIF.


*   """"""""READ TABLE CON CLAVE LIBRE (SE PUEDE USAR UN CAMPO LIBRE PARA ACCEDER NO SOLA LA KEY)"""""""""

    "FORMA 1, USANDO READ TABLE
    SELECT FROM /dmo/airport        "RELLENADO DE TABLA SIN FILTRO
     FIELDS *
     INTO TABLE @lt_flights.

    out->write( | | ).
    out->write( | | ).
    out->write( | """"""""""READ TABLE CON KEY """"""""""| ).

    out->write( data = lt_flights name = 'Tabla Entera Sin Filtros' ).    "IMPRESION DE TABLA ENTERA


    READ TABLE lt_flights INTO DATA(ls_flight) WITH KEY city = 'Berlin'.  "USANDO UN CAMPO LIBRE DE LA TABLA(DEVUELVE EL 1ER REGISTRO CON ESE CAMPO)
    out->write( | | ).
    out->write( data = ls_flight name = 'Registro Leido (Key Campo Cualquiera)' ).


    "FORMA 2, EXPRESIONES DE TABLA
    out->write( | | ).
    DATA(lt_flight_2) = lt_flights[ airport_id = 'JFK' ]. "SE USA UNA STRUCTURA AUXILIAR (Work areas)
    out->write( data = lt_flight_2 name = 'Registro Leido (Key Campo Cualquiera Usando Expresiones de tabla)' ).

    "FORMA 2, EXPRESION DE TABLA, TRAER UN CAMPO ESPECIFICO, NO TODO EL REGISTRO
    out->write( | | ).
    DATA(lv_flight) = lt_flights[ airport_id = 'JFK' ]-name .  "YA QUE SOLO RECIBE UN VALOR SE USA UNA VARIABLE 1DIMENSIONAL
    Out->write( data = lv_flight name = 'Registro Leido (UN SOLO CAMPO USANDO KEY (CAMPO) CUALQUIERA)' ).

    out->write( | | ).
    out->write( | | ).

*    """"""""""READ TABLE CON CAMPO PRIMARY KEY
    DATA gt_flight_sort TYPE SORTED TABLE OF /dmo/airport WITH NON-UNIQUE KEY airport_id. "DECLARACION DE TABLA SORT CON CLAVE NO UNICA(SE PUEDE HABER DUPLICADOS EN EL CAMPO KEY)

    SELECT FROM /dmo/airport        "RELLENADO DE TABLA SIN FILTRO
    FIELDS *
    INTO TABLE @gt_flight_sort.

    READ TABLE gt_flight_sort INTO DATA(ls_flight_sort) WITH TABLE KEY airport_id = 'LAS'. "SE USA WITH TABLE KEY(LLABE PRIMARIA DE LA TABLA)
    Out->write( data = gt_flight_sort name = 'Tabla Sort (Completa)' ).
    out->write( | | ).
    Out->write( data = ls_flight_sort name = 'Registro Leido (Key Primaria)' ).
    out->write( | | ).

    "EXPRESION DE TABLA PRIMARY KEY
    DATA(ls_flight_sort_2) = gt_flight_sort[ KEY primary_key airport_id = 'LAS' ].
    Out->write( data = ls_flight_sort_2 name = 'Registro Leido (EXPRESION DE TABLA)(Key Primaria)' ).

  ENDMETHOD.
ENDCLASS.
