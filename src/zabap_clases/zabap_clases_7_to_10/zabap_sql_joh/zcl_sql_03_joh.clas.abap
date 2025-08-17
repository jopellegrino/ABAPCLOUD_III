CLASS zcl_sql_03_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SQL_03_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*  """""ACTUALIZAR UN REGISTRO (LAS KEY NO SE PUEDE ACTUALIZAR, SOLO SE PUEDEN ELIMINAR Y VOLVER A CREAR DICHO REGISTRO SI DESEAS MODIFICAR LA KEY)

    DATA ls_airline TYPE zcarrier_joh.

    SELECT SINGLE FROM zcarrier_joh
    FIELDS *
    WHERE carrier_id = 'AA'
    INTO @ls_airline.

    IF sy-subrc = 0.
      out->write( | Current Currency: { ls_airline-currency_code } | ).
    ENDIF.

    ls_airline-currency_code = 'EUR'.               "FORMA 1. MODIFICACION EL CAMPO DE LA STRUC.

    ls_airline = VALUE #( carrier_id    = 'AA'      "FORMA 2. LA STRUC.
                          currency_code = 'USD'
                           namecompany  = 'American Airlines'  ).



    UPDATE zcarrier_joh FROM @ls_airline.  "ACTUALIZACION DE LA BBDD CON LA STRUC. "TODOS LOS CAMPOS DEL ROW SE ACTUALIZAN CON UPDATE

    IF sy-subrc = 0.
      out->write( | Campo modificado de currency: { ls_airline-currency_code } | ).
    ENDIF.



*   """""ACTUALIZAR MULTIPLES REGISTROS

    CONSTANTS lc_currency TYPE c LENGTH 3 VALUE 'USD'.

    SELECT FROM zcarrier_joh
           FIELDS *
           INTO TABLE @DATA(lt_airlines).

    IF sy-subrc = 0.

      LOOP AT lt_airlines ASSIGNING FIELD-SYMBOL(<lfs_airlines>).   "RECORRE LA ITAB Y ASIGNA NUEVOS VALORES AL CURRENCY
        <lfs_airlines>-currency_code = lc_currency.
      ENDLOOP.

      UPDATE zcarrier_joh FROM TABLE @lt_airlines.                  "VOLCAMOS LOS VALORES ASIGNADOS A LA ITAB SOBRE LA BBDD

      IF sy-subrc = 0.
        out->write( | Todos los registros han sido actualizados, con la nueva moneda| ).
      ENDIF.

    ENDIF.













  ENDMETHOD.
ENDCLASS.
