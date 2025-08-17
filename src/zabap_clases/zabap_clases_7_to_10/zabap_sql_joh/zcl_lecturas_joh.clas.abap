CLASS zcl_lecturas_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LECTURAS_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""SELECT SINGLE  (TRAE UN SOLO REGISTRO)

    out->write( '"""""SELECT SINGLE"""""' ).

    SELECT SINGLE FROM zcarrier_joh     "TRAE EL REGISTRO CON ESA KEY, SI COLOCAS OTRO CAMPO, TE TRAE EL PRIMERO CON ESE CAMPO
      FIELDS *
      WHERE carrier_id = 'AA'
      INTO @DATA(ls_airline).             "ESTO ES UNA STRUC. NO UNA ITAB

    IF sy-subrc = 0.                    "VERIFICA EL CORRECTO SELECT
      out->write( ls_airline ).         "IMPRIME EL REGISTRO TRAIDO EN LA STRUC.
    ENDIF.
    out->write( | | ).


*   """""SELECT BYPASSING BUFFER (SALTA LA LECTURA DE LA ZONA DEL BUFFER SI HUBIERA EN UN SELECT Y VA DIRECTO A LA BBDD)

    out->write( '""""""SELECT BYPASSING BUFFER""""""' ).
    SELECT SINGLE FROM zcarrier_joh
        FIELDS *
        WHERE carrier_id = 'AA'
        INTO @ls_airline BYPASSING BUFFER.   "EL PRIMER SELECT NO USA BUFFER, PERO LAS SIGUIENTES AL MISMO REGISTRO LO INTENTARA, PERO AL COLOCAR ESTO NO LO HARA

    IF sy-subrc = 0.
      out->write( ls_airline ).
    ENDIF.
    out->write( | | ).



*   """""SELECT INTO y SELECT APPENDING TABLE (PERMITE CONCATENAR REGISTROS EN UNA ITAB DE DIFERENTES SELECT)

    out->write( '"""""SELECT APPEDING"""""' ).

    DATA lt_airline_02 TYPE STANDARD TABLE OF zcarrier_joh.

    SELECT FROM zcarrier_joh                 "SE TRAE LOS DATOS DE LA BBDD
        FIELDS *
        WHERE currency_code = 'USD'
        INTO TABLE @lt_airline_02.           "CUANDO USAS UNA ITAB EN UN SELECT Y QUE VENIA CON DATOS DE OTRO LUGAR REUSARLA HACE QUE SE PIERDAN CUANDO USAS INTO

    IF sy-subrc = 0.

      APPEND INITIAL LINE TO lt_airline_02.  "AGREGA UNA LINEA VACIA AL FINAL DE LA ITAB

      out->write( data = lt_airline_02 name = 'DATOS INICIALES' ).

      SELECT FROM zcarrier_joh
        FIELDS *
        WHERE currency_code = 'EUR'
        APPENDING TABLE @lt_airline_02.      "ESTO HACE QUE SE AGREGEN ESTOS NUEVOS DATOS A LA ITAB SIN PERDER LOS ANTERIORES

      out->write( data = lt_airline_02 name = 'DATOS INICIALES + NUEVOS' ).

    ENDIF.







  ENDMETHOD.
ENDCLASS.
