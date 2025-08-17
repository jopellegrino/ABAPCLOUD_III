CLASS zcl_sql_01_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SQL_01_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    """""INSERT UN REGISTRO (USANDO STRUC.)

    DATA ls_airline TYPE zcarrier_joh.

    ls_airline = VALUE #( carrier_id = 'AA'         "EL VALOR DE CLIENT LO INSERTA EL SISTEMA
                           namecompany = 'American Airlines'
                           currency_code = 'USD'   ).

    "INSERT INTO zcarrier_joh VALUES @ls_airline.    "FORMA UNO DE INSERTAR

    "INSERT zcarrier_joh FROM @ls_airline.           "FORMA DOS DE INSERTAR (RECOMENDADA)


    IF sy-subrc = 0.
      out->write( |El registro se ha insertado correctamente Ejem. 1| ).
    ELSE.
      out->write( |El registro NO se ha insertado correctamente Ejem. 1| ).
    ENDIF.


*    """""INSERT UN REGISTRO (MANUAL.)

        INSERT zcarrier_joh FROM @( VALUE #(  carrier_id    = 'AA'
                                                 namecompany   = 'American Airlines'
                                                 currency_code = 'USD'                ) ).







*   """"""INSERT MULTIPLES REGISTROS (USANDO ITAB) (CON TRATAMIENTO EN CAPA ABAP)

    DELETE FROM zcarrier_joh.                            "INTRUCCION PELIGROSA, NO USAR EN SISTEMAS DE EMPRESA

    DATA lt_ddbb TYPE STANDARD TABLE OF zcarrier_joh.    "SE CREA UNA TABLA DEL MISMO QUE LA DE BBDD

    SELECT FROM /DMO/I_Carrier
    FIELDS *
    WHERE CurrencyCode = 'USD'
    INTO TABLE @DATA(lt_airline).                        "SE DESCARGAN LOS DATOS DE UNA FUENTE EXTERNA

    IF sy-subrc = 0.

      lt_ddbb = CORRESPONDING #( lt_airline MAPPING carrier_id    = AirlineID       "SE VOLCAN LOS DATOS DE LA FUENTE EXTERNA A LA TABLA DEL MISMO TIPO QUE LA DE BBDD
                                                    currency_code = currencycode
                                                    namecompany = name ).


      INSERT zcarrier_joh FROM TABLE @lt_ddbb.            "SE INSERTAN LOS DATOS DE UNA ITAB Y SE SUBEN A LA BBDD

      IF sy-subrc = 0.
        out->write( |Los registros se ha insertado correctamente { sy-dbcnt } del Ejem. 2| ).
      ELSE.
        out->write( |Los registros NO se ha insertado correctamente del Ejem. 2| ).
      ENDIF.
    ENDIF.


*    """""INSERT MULTIPLES REGISTROS (USANDO ITAB) (CON TRATAMIENTO CAPA HANA)

    DELETE FROM zcarrier_joh.

    SELECT FROM /DMO/I_Carrier                      "SE TRAEN SOLO LOS FIELDS NECESARIOS Y SE VOLCAN EN UNA ITAB
      FIELDS AirlineID     AS  carrier_id,
             currencycode  AS  currency_code,
             name          AS  namecompany
      WHERE CurrencyCode = 'USD'
      INTO CORRESPONDING FIELDS OF TABLE @lt_ddbb.  "MAPEO EN LOS CAMPOS QUE CORRESPONDEM

    IF sy-subrc = 0.                  "VERIFICA LA LECTURA DE BBDD

      INSERT zcarrier_joh FROM TABLE @lt_ddbb.

      IF sy-subrc = 0.                "VERIFICA LA CORRECTA INSERT
        out->write( |Los registros se ha insertado correctamente { sy-dbcnt } del Ejem. 3| ).
      ELSE.
        out->write( |Los registros NO se ha insertado correctamente del Ejem. 3| ).
      ENDIF.

    ENDIF.


*    """""INSERT MULTIPLES REGISTROS (DATOS MANUAL)


    INSERT zcarrier_joh FROM TABLE @( VALUE #( ( carrier_id    = 'AA'
                                                 namecompany   = 'American Airlines'
                                                 currency_code = 'USD'               )

                                                ( carrier_id    = 'DL'
                                                 namecompany   = 'Delta Air Lines, Inc.'
                                                 currency_code = 'USD'               )                                                ) ).













  ENDMETHOD.
ENDCLASS.
