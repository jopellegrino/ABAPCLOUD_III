CLASS zcl_18_itab_insert_y_append DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_18_itab_insert_y_append IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "KEY UNICA O NO UNICA IDENTIFICA SI PUEDE HABER MAS DE UN REGISTRO CON LA MISMA KEY (PARA LA KEY (CLAVE) SE USA UN CAMPO DE LA TABLA


*    """"""DECLARACION DE TABLA ESTANDAR, SI SE HACE EN LINEA TAMBIEN CREA STANDARD"""""""""

    DATA: lt_flight_stand     TYPE STANDARD TABLE OF /dmo/flight WITH EMPTY KEY,   "AMBAS SON TIPO STANDARD, Y NO ES NECESARIO ESPECIFICAR LA CLAVE (KEY)
          lt_lt_flight_stand2 TYPE TABLE OF /dmo/flight.                           "PUEDE TENER CLAVE VACIA "with EMPTY KEY"



*    """""""""DECLARACION DE TABLA SORTED""""""""""

    DATA LT_flight_SORT TYPE SORTED TABLE OF /dmo/flight WITH NON-UNIQUE KEY carrier_id.   "SE DEBE INDICAR CLAVE EXPLICITA EN LA DECLARACION, LA TABLA SE ORGANIZA POR LA KEY, SI NO SE COLOCA LA KEY EXPLICITA SE COLOCA LA STANDARD SOLA



*    """""""DECLARACION DE TABLA INTERNA HASHED "LA CLAVE OBLIG. DEBE SER UNICA""""""""""

    DATA lt_flight_hash TYPE HASHED TABLE OF /dmo/flight WITH UNIQUE KEY carrier_id.  "PUEDE SER CLAVE UNICA O NO UNICA, ESTO SIGNIFICA QUE EL VALOR DE CAMPO CLAVE PUEDE O NO REPETIRSE EN LOS REGISTROS


*    """""""""""AÑADIR REGISTROS""""""""""

    DATA: lt_employees  TYPE STANDARD TABLE OF zemploy_table, "CREACION DE TABLA DE BASE DE DATOS VidEnVivo4. MIN:52
          ls_employee   TYPE zemploy_table,
          lt_employees3 LIKE lt_employees.

    TYPES lty_employee LIKE Lt_EMPLOYEES. "DECLARACION DE UN TIPO CON LA MISMA ESTRUCTURA QUE EL DE ARRIBA
    out->write( | | ).

    "PRIMERA FORMA
    lt_employees = VALUE #( ( id            =  0000
                              first_name    = 'Jose'
                              last_name     = 'Perez'
                              email         = 'joperez@gmail.com'
                              phone_numer   = '1234567'
                              salary        = '2000.3'
                              currency_code = 'EUR' )  ).

    "SEGUNDA FORMA
    DATA(lt_employees2) = VALUE lty_employee( ( id            =  0001           "CUANDO SE HACE UNA ITAB CON DECL. EN LINEA NO SE PUEDE USAR AUTOREFERENCIA # (SE DEBE COLOCAR EL TIPO DIRECTAMENTE)
                                                first_name    = 'Pedro'
                                                last_name     = 'Perez'
                                                email         = 'PEDROperez@gmail.com'
                                                phone_numer   = '1011127'
                                                salary        = '2050.3'
                                                currency_code = 'EUR' )

                                               ( id            =  0002
                                                 first_name    = 'Maria'
                                                 last_name     = 'Perez'
                                                 email         = 'Mariaperez@gmail.com'
                                                 phone_numer   = '1456123'
                                                 salary        = '2001.3'
                                                 currency_code = 'USD' )  ).


    out->write( data = lt_employees name = 'Añadir de tabla 1ero (EMPLOYEES)' ).
    out->write( data = lt_employees2 name = 'Añadir de tabla 2do (EMPLOYEES2)' ).
    out->write( | | ).

*    """"""""""INSERTAR REGISTROS""""""""""SE PUEDE ESPECIFICAR EL INDICE, SORT Y HASH SOLO SE PUEDE CON INSERT Y APEND SE AÑADE AL FINAL Y SOLO STANDARD
    "ES RECOMENDABLE SIEMPRE USAR INSERT PARA TODAS LOS TIPOS DE TABLAS

    "FORMA ANTIGUA
    ls_employee-id             = 0004.          "SE USA EL TIPO DE DATO STRUCTURA SE LLENA Y LUEGO SE VOLCA DENTRO DE LA TABLA, DEBEN SER COMPATIBLES
    ls_employee-currency_code  = 'COP'.
    ls_employee-email          = 'tomasramirez@gmail.com'.
    ls_employee-first_name     = 'Tomas'.
    ls_employee-last_name      = 'Ramirez'.
    ls_employee-phone_numer    = 666666555.
    ls_employee-salary         = '2000.1'.

    INSERT ls_employee INTO TABLE lt_employees.

    out->write( data = lt_employees name = 'Añadir de tabla 3ero (EMPLOYEES)' ).
    out->write( | | ).


    "FORMA ACTUAL (INSERT VALUE)

    INSERT VALUE #( id             = 0005           "LA DIFERENCIA ENTRE AMBAS FORMAS QUE LA ANTIGUA NECESITA UNA STRUCTURA AUXILIAR PARA INSERTAR LOS DATOS Y LA MODERNA NO
                    currency_code  = 'BSF'
                    email          = 'petrojime@gmail.com'
                    first_name     = 'Petro'
                    last_name      = 'Jimenez'
                    phone_numer    = 633333335
                    salary         = '3300.1' ) INTO TABLE lt_employees.



    INSERT INITIAL LINE INTO TABLE lt_employees.        "INSERTAR LINEA BLANCA A LA TABLA

    out->write( data = lt_employees name = 'Añadir de tabla 4to (EMPLOYEES)' ).

    out->write( | | ).

    "INSERTAR EN UN NUM DE REGISTRO

    INSERT VALUE #( id             = 0007
                   currency_code  = 'BSF'
                   email          = 'petrojime@gmail.com'
                   first_name     = 'Gianluca'
                   last_name      = 'Giuliano'
                   phone_numer    = 6444445
                   salary         = '5500.1' ) INTO lt_employees INDEX 2. "CUANDO NO SE COLOCA INDICE SIEMPRE SE AGREGA AL FINAL EL REGISTRO


    out->write( data = lt_employees name = 'Añadir de tabla 5to (EMPLOYEES)' ).
    out->write( | | ).

    "INSERT (LLENAR UNA TABLA CON EL CONTENIDO DE OTRA TABLA)

    INSERT LINES OF lt_employees INTO TABLE lt_employees3.

    out->write( data = lt_employees3 name = 'INSERT DATOS DE UNA TABLA EN OTRA (EMPLOYEE 3)' ).
    CLEAR lt_employees3.

    out->write( | | ).


    "INSERT (HASTA UN NUMERO REGISTRO)

    INSERT LINES OF lt_employees TO 1 INTO TABLE lt_employees3.
    out->write( data = lt_employees3 name = 'INSERT DATOS DE UNA TABLA EN OTRA, HASTA UN REGISTRO ESPECIFICO (EMPLOYEE 3)' ).
    CLEAR lt_employees3.
    out->write( | | ).

    "TAMBIEN EXISTE APPEND LINES OF..


    "INSERT (DESDE UN REGISTRO HASTA OTRO REGISTRO)

    INSERT LINES OF lt_employees FROM 1 TO 3 INTO TABLE lt_employees3.
    out->write( data = lt_employees3 name = 'INSERT DATOS DE UNA TABLA EN OTRA, DESDE Y HASTA UN REGISTRO ESPECIFICO (EMPLOYEE 3)' ).
    out->write( | | ).

*    """"""""""APPEND""""""""""(AÑADE AL FINAL)(SOLO TIPO STANDARD)


    """"""PRIMERA FORMA (USA LS AUXILIAR Y LUEGO SE VUELCA EN LA LT
    CLEAR lt_employees.
    ls_employee-id             = 0010.          "SE USA EL TIPO DE DATO STRUCTURA SE LLENA Y LUEGO SE VOLCA DENTRO DE LA TABLA, DEBEN SER COMPATIBLES
    ls_employee-currency_code  = 'LBR'.
    ls_employee-email          = 'petrogomez@gmail.com'.
    ls_employee-first_name     = 'Petro'.
    ls_employee-last_name      = 'Gomez'.
    ls_employee-phone_numer    = 12121212.
    ls_employee-salary         = '3500.1'.

    APPEND INITIAL LINE TO lt_employees.             "AGREGA LINEA EN BLANCO

    APPEND ls_employee TO lt_employees.              "DE DONDE SALE LA INFO TO A DONDE VOLCAS LA INFO
    out->write( data = lt_employees name = 'APPEND EN TABLA STANDARD CON LS AUX (EMPLOYEE)' ).



    """"""SEGUNDA FORMA (USANDO VALUE)

    APPEND VALUE #( id             = 0011
                    currency_code  = 'RLS'
                    email          = 'Joao24@gmail.com'
                    first_name     = 'Joao'
                    last_name      = 'Gomez'
                    phone_numer    = 99999999
                    salary         = '2200.1' ) TO LT_employees.

    out->write( data = lt_employees name = 'APPEND EN TABLA STANDARD CON VALUE (EMPLOYEE)' ).







  ENDMETHOD.
ENDCLASS.
