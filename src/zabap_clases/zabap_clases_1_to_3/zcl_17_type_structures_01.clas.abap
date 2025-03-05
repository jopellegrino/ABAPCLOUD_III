CLASS zcl_17_type_structures_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_17_type_structures_01 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA ls_flight TYPE /dmo/flight.            "ESTA STRUC. ES LOCAL(SOLO AQUI) Y SOLO TIENE EL TAMAÑO DE UNA FILA DE LA TABLA /DMO/FLIGHT OSEA (1) REGISTRO
    "SI QUIERES QUE SEA GLOBAL DEBES DE COLOCARLA EN EL DICCIONARIO DE DATOS

    "DEFICION DE TYPE STRUCTURE
    TYPES: BEGIN OF lty_employee,               "LTY (LOCAL TYPE) DECLARACION DE TIPO STRUCTURADO LOCAL (PLANTILLA NO RESERVA MEMORIA)
             name  TYPE string,
             id    TYPE i,
             email TYPE /dmo/flight,
           END OF lty_employee.



    "DEFICION, DECLARACION E INICIALIZACION DE STRUCTURE
    DATA: BEGIN OF ls_employee,                 "LS (LOCAL STRUCTURE) YA QUE ESTA ES UNA STRUCTURA YA DEFINIDA Y LISTA PARA USAR (RESERVO MEMORIA)
            name  TYPE string VALUE 'LAURA',    "DEFINICION, DECLARACION E INICIALIZACION
            id    TYPE i,
            email TYPE /DMO/email_address,
          END OF ls_employee.


    "DECLARACION DE TABLA INTERNA Y STRUCTURE USANDO LAS STRUCTURAS ANTERIORES
    DATA lt_employees TYPE TABLE OF lty_employee.    "ITAB CON LOS CAMPOS DE lty_employee PERO N REGISTROS

    DATA ls_empl TYPE lty_employee.                  "STRUCTURE CON LOS CAMPOS DE lty_employee PERO (1) REGISTRO

    DATA ls_empl2 LIKE ls_employee.                  "TOMA EL TYPO DE UNA STRUCTURA YA EXISTENTE (SIRVE CUANDO QUIERES QUE UNA VARIABLE TENGA EL MISMO TIPO QUE OTRO)
    DATA(ls_empl3) = ls_employee.                    "DA EL MISMO RESULTADO QUE ARRIBA YA QUE DEFINE EL TIPO DE EMPL3 A TRAVES DEL TIPO DE EMPLOYEE, NO SIRVE CON UNA PLANTILLA.


    DATA(ls_empl4) = VALUE lty_employee( name = 'MARIA'
                                          id = 52
                                          email = 'aa@gmail.com'

                                            ).       "YA QUE LE PASE EL TIPO DE DATOS LA DECLARACION (TYPO STRUCTURADO) E INICIALIZO, AL COLOCAR LOS TIPOS DE DATOS EL ENTIENDE EL TIPO


    "ESTRUCTURAS ANIDADAS (NESTED STRUCTURE)   "STRUCTURE FLAT (ESTRUCTURA PLANA) SOLO CONTIENE TIPO ELEMENTALES

    DATA: BEGIN OF LS_empl_info,                                        "BLOQUE PADRE

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

          END OF LS_empl_info.

    out->write( data = LS_empl_info name = 'Employee Info' ).     "MUESTRA LOS DATOS DE LA STRUCTURA EN CONSOLA

    out->write( | | ).

    "DEEP STRUCTURE (TIENE UN COMPONENTE UNA TAB, CADENA, TIPO DE REFERENCIA ETC)

    TYPES: BEGIN OF lty_flights,                                  "CONTIENE LOS CAMPOS DE LA TABLA FLIGHT (TRANSPARENTE) OSEA SE COLOCA EL NOMBRE DE LA TABLA-CAMPO
             flight_date   TYPE /dmo/flight-flight_date,
             price         TYPE /dmo/flight-price,
             currency_code TYPE /dmo/flight-currency_code,
           END OF lty_flights.

    DATA: BEGIN OF ls_flight_info,                                "ES UNA STRUCTURA PROFUNDA PORQUE TIENE UNA TABLA INTERNA, LOS CAMPOS QUE NO SON LA TABLA SE RELLENARON CON VALUE
            carrier    TYPE /dmo/flight-carrier_id VALUE 'AA',
            connind    TYPE /dmo/flight-connection_id VALUE '0018',
            lt_flights TYPE TABLE OF lty_flights WITH EMPTY KEY,
          END OF ls_flight_info.


    SELECT *                                                      "SE RELLENO LA TABLA QUE CONTIENE LA DEEP STRUCTURE CON LOS DE LA TABLA DE PRUEBA
    FROM /dmo/flight
    WHERE carrier_id EQ 'AA'                                      "TRAE SOLO LOS REGISTROS QUE CUMPLEN LA CONDICION
    INTO CORRESPONDING FIELDS OF TABLE @ls_flight_info-lt_flights
    UP TO 4 ROWS.                                                 "HACE QUE SOLO SE TRAIGAN 4 REGISTOS DE ESTA TABLA

    out->write( data = ls_flight_info name = 'Nombre: ls_flight_info' ).


  ENDMETHOD.
ENDCLASS.
