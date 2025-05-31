CLASS zcl_16_type_structures_02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_16_TYPE_STRUCTURES_02 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "ACCESO (RELLENADO DE LA STRUCTURA)
    out->write( |"""RELLENADO DE DATOS O ACCESO"""| ).
    TYPES: BEGIN OF lty_flights,                                    "STRUCTURA USADA PARA CREAR LA TABLA
             flight_date   TYPE /dmo/flight-flight_date,
             price         TYPE /dmo/flight-price,
             currency_code TYPE /dmo/flight-currency_code,
           END OF lty_flights.

    DATA: BEGIN OF ls_flight_info,                                  "STRUCTURA PROFUNDA
            carrier    TYPE /dmo/flight-carrier_id VALUE 'AA',
            connind    TYPE /dmo/flight-connection_id VALUE '0018',
            lt_flights TYPE lty_flights,                            "ESTA STRUCTURA ESTA COMPUESTA POR 3 CAMPOS MAS (VER ARRIBA)
          END OF ls_flight_info.


    "RELLENADO 1 (ACCESO 1)

    ls_flight_info-carrier = 'XX'.      "LLENADO DE CAMPOS SIMPLES
    ls_flight_info-connind = '0022'.

    ls_flight_info-lt_flights-flight_date = cl_abap_context_info=>get_system_date(  ). "RELLENA DE CAMPOS DE LA STRUCTURA CON LA FECHA ACTUAL
    ls_flight_info-lt_flights-price = '200'.
    ls_flight_info-lt_flights-currency_code = 'USD'.

    IF ls_flight_info-carrier EQ 'XX'.                                                 "PARA PROBAR QUE SE PUEDE COLOCAR EN UN IF
      out->write( data = ls_flight_info name = 'INFORMACION DE FLIGHT RELLENADO 1ERO' ).
    ENDIF.

    out->write( | | ).

    "RELLENADO 2 (ACCESO 2)(NESTED STRUCTURE)

    DATA: BEGIN OF ls_empl_info,
            BEGIN OF info,
              id         TYPE i VALUE 1234,
              first_name TYPE string VALUE 'Luara',
              Last_name  TYPE string VALUE 'Perez',
            END OF info,

            BEGIN OF adress,
              city    TYPE string VALUE 'Frankfurt',
              street  TYPE string VALUE 'Main Street',
              country TYPE string VALUE 'Germany',
            END OF adress,

            BEGIN OF position,
              department TYPE string VALUE 'IT',
              salary     TYPE p DECIMALS 2 VALUE '2000.21',
            END OF position,
          END OF ls_empl_info.

    ls_empl_info = VALUE #( info =     VALUE #( id = 1234              first_name = 'Juan'    last_name = 'Perez' )  "PARA QUE EL COMPILADOR SEPA EL TIPO, YA QUE ESTA STRUCTURA YA TIENE VALORES SE PUEDE USAR LA AUTOREFERENCIA #,
                            adress =   VALUE #( city = 'Caracas'       country = 'Venezuela'  street = 'Bolivar' )   " SI FUERA UNA DECLARACION EN LINEA SE CAMBIA EL # POR UN TIPO DE DATO
                            position = VALUE #( department = 'Calidad' salary = '2500' )    ).


    out->write( data = ls_empl_info name = 'INFORMACION DE FLIGHT RELLENADO 2DO' ).

    out->write( | | ).


    "ELIMINAR DATOS (DELETE)
    out->write( |"""ELIMINACION DE DATOS"""| ).

    SELECT SINGLE FROM /dmo/flight          "TRAE SOLO UNA LINEA DEL REGISTRO DE LA BASE DE DATOS DE UNA TABLA DEMO DEL STANDAR
    FIELDS *                                "TRAE TODOS LOS CAMPOS DE ESE REGISTRO UNICO
    WHERE carrier_id EQ 'LH'                "FILTRO DE LOS DATOS TRAIDOS LOS CUALES CUMPLAN LA CONDICION
    INTO @DATA(ls_flight2).                 "UNA DECLARACION EN LINEA DE UNA STRUCTURA DONDE VOLCAR EL REGISTRO

    out->write( data = ls_flight2 name = 'IMPRESION SIN ELIMINAR DATOS' ).  "IMPRESION ESTADO NATURAL CON TODA LA INFO

    CLEAR ls_flight2-connection_id.             "ELIMINACION DE CAMPOS ESPECIFICOS
    out->write( data = ls_flight2 name = 'IMPRESION CON (1) CAMPO ELIMINADO' ).

    CLEAR ls_flight2.                            "ELIMINACION DE TODOS LOS CAMPOS
    out->write( data = ls_flight2 name = 'IMPRESION CON TODOS LOS CAMPOS ELIMINADOS' ).


    "INCLUDE (INCLUDE TYPE PARA INCLUIR UN TIPO STRUCURADO DENTRO DE LOS COMPONENTES)(INCLUDE STRUCTURE PARA INCLUIR UNA STRUCTURA)
    out->write( | | ).
    out->write( |"""ESTRUCTURA INCLUDE"""| ).

    TYPES: BEGIN OF purchase_order_type, "STRUCTURA ANIDADA
             order_id   TYPE i,
             order_date TYPE d,
           END OF purchase_order_type,

           BEGIN OF supplier_type,
             supplier_id TYPE i,
             name        TYPE string,
           END OF supplier_type,

           BEGIN OF material_type,
             material_id TYPE i,
             name        TYPE string,
           END OF material_type.

    DATA ls_mat TYPE material_type.   "ESTRUCTURA DECLARADA


    TYPES BEGIN OF invoice_type.          "DECLARACION DE ESTRUCTURA TIPO INCLUDE (SE TRAE LOS CAMPOS DE LAS ESTRUCTURAS USADAS PARA CREALO)

    INCLUDE TYPE purchase_order_type AS purchase.                                  "SE LE ASIGNO UN ALIAS PARA REDUCIR EL NOMBRE
    INCLUDE TYPE supplier_type AS supplier RENAMING WITH SUFFIX _supplier.         "HAY DOS CAMPOS LLAMADOS NAME EN DOS ESTRUCTURAS USADAS ENTONCES PARA DIFERENCIARLOS SE AGREGA SUFIJO
    INCLUDE STRUCTURE ls_mat AS mat RENAMING WITH SUFFIX _mat.                     "INCLUDE STRUCTURE Y SE RENOMBRA PARA NO DUPLICAR EL CAMPO NAME

    TYPES END OF invoice_type.

    DATA: ls_invoice  TYPE invoice_type,                            "PARA METERLE DATOS SE DEBE DECLARAR
          ls_purchase TYPE purchase_order_type.                     "ESTA PARTE NO ES NECESARIA PARA LLENAR LA ESTRUCTURA INCLUDE PERO ES IMPORTANTE SABER QUE LOS DATOS PUEDEN VENIR DE UNA LS VID2.8

    ls_purchase = VALUE #( order_date = '20250101' order_id = 1234  ). "ESTRUCTURA INDIVIDUAL RELLENADA PARA VOLCARLA ENCIMA DE LA INCLUDE (EN PURCHASE)

    "RELLENADO DE ESTRUCTURA INCLUDE
    ls_invoice = VALUE #( purchase = ls_purchase

                          supplier-supplier_id = 123
                          name_supplier = 'XX'                      "ESTO ES OTRA FORMA DE AGREGARLO YA QUE AGREGAMOS SUFIJOS

                          mat-material_id = 123     "RELLADO CON -
                          name_mat = 'Mat1'         "RELLANDO CON CAMPO_SUFIJO

       ).

    out->write( data = ls_invoice name = 'ESTRUCTURA INCLUDE' ).

  ENDMETHOD.
ENDCLASS.
