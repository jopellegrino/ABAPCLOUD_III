CLASS zcl_sql_06_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sql_06_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""INSTRUCCION DELETE A UN REGISTRO (CON CUIDADO)

    SELECT SINGLE FROM zcarrier_joh           "SE TRAE EL REGISTO QUE SE DESEA ELIMINAR
    FIELDS *
    WHERE carrier_id = 'UA'
    INTO @DATA(ls_airline).


    "FORMA 1 (INFORMANDO TODOS LOS DATOS DE LA COLUMNA A ELIMINAR)
    IF sy-subrc = 0.                           "VERIFICA QUE EL SELECT SE REALICE CORRECTAMENTE

      DELETE zcarrier_joh FROM @ls_airline.    "SE SOLICITA LA ELIMINAR DEL REGISTRO DE LA TABLA DE BBDD QUE TIENE LO MISMO QUE LA STRUC.

      IF sy-subrc = 0.
        out->write( 'Record deleted from the database (Forma 1)' ).
      ENDIF.

    ENDIF.



    "FORMA 2 (INFORMANDO SOLO LA KEY DE LA COLUMNA A ELIMINAR

    DATA(ls_airline_02) = VALUE zcarrier_joh( carrier_id = 'WZ' ).

    DELETE zcarrier_joh FROM @ls_airline_02.

    IF sy-subrc = 0.
      out->write( 'Record was delete from database (Forma 2)' ).

    ELSE.
      out->write( 'Record not available for the deletion (Forma 2)' ).
    ENDIF.



*   """""DELETE MULTIPLES REGISTROS

    DATA lt_airlines TYPE STANDARD TABLE OF zcarrier_joh.

    SELECT FROM zcarrier_joh        "SE TRAEN LOS REGISTROS A BORRAR A UNA ITAB FILTRANDO
           FIELDS *
           WHERE currency_code = 'EUR'
    INTO TABLE @lt_airlines.

    "TAMBIEN SE PUEDE MANDAR SOLO UNA KEY Y TAMBIEN FUNCIONA DELETE
*    SELECT FROM zcarrier_joh
*           FIELDS carrier_id                "SOLO TRAE EL CAMPO CARRIER_ID QUE ES KEY
*           WHERE currency_code = 'EUR'
*    INTO CORRESPONDING FIELDS OF TABLE @lt_airlines.

    IF sy-subrc = 0.                "VERIFICACION DEL SELECT

      DELETE zcarrier_joh FROM TABLE @lt_airlines.


      IF sy-subrc = 0.             "VERIFICACION DE DELETE
        out->write( 'Records deleted from database' ).
      ENDIF.

    ELSE.
      out->write( 'Record with EUR is not available' ).
    ENDIF.






  ENDMETHOD.
ENDCLASS.
