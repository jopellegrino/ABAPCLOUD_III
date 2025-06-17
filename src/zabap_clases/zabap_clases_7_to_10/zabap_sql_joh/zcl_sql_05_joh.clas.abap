CLASS zcl_sql_05_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sql_05_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*  """""MODIFY SINGLE ROW (MIDIFY ACTUA COMO INSERT(CUANDO NO EXISTE EL ROW) O UPDATE(CUANDO EXISTE EL ROW)

    "ACTUA COMO INSERT (YA QUE NO EXISTE ESTE ROW)

    DATA(ls_airline) = VALUE zcarrier_joh( carrier_id    = 'WZ'
                                           namecompany   = 'Wizz Air'
                                           currency_code = 'EUR'     ).

    MODIFY zcarrier_joh FROM @ls_airline.

    IF sy-subrc = 0.
      out->write( |The row was updated/inserted correctly| ).
    ELSE.
      out->write( |The row was not updated/inserted correctly| ).    "MODIFY DIFICILMENTE TIENE ERROR AL USARLO YA QUE SIEMPRE INSERTA O MODIFICA
    ENDIF.



*    """""MODIFY MULTIPLE ROWS (INSERTAR(INSERT) NUEVOS REGISTROS Y MODIFICAR(UPDATE) UNOS EXISTENTES)

    CONSTANTS lc_currency TYPE c LENGTH 3 VALUE 'EUR'.

    SELECT FROM zcarrier_joh
           FIELDS *
           WHERE carrier_id = 'LH'                  "SE TRAEN A LA ITAB LOS REGISTROS QUE CUMPLEN ESTAS CONDICIONES
              OR carrier_id = 'AF'
           INTO TABLE @DATA(lt_airline).

    IF sy-subrc = 0.

      LOOP AT lt_airline ASSIGNING FIELD-SYMBOL(<fs_airline>).      "ESTE BUCLE CAMBIA TODOS LOS CURRENCY_CODE TRAIDOS EN LA ITAB A EUR, ASI QUE HACE UPDATE
        <fs_airline>-currency_code = lc_currency.
      ENDLOOP.

      APPEND VALUE #( carrier_id    = 'AV'
                      namecompany   = 'Avianca'
                      currency_code = 'COP'     ) TO lt_airline.     "ESTE ES UN REGISTOS NUEVO, ASI QUE HACE INSERT

      MODIFY zcarrier_joh FROM TABLE @lt_airline.                    "TODAS LAS ASIGNACIONES A LAS ITAB AHORA SE VOLCAN A LA BBDD

      IF sy-subrc = 0.
        out->write( |Record was updated/inserted correctly| ).
      ELSE.
        out->write( |Record was NOT updated/inserted correctly| ).
      ENDIF.


    ENDIF.                                                            "SE PUEDE HACER UN TRATAMIENTO DE EXEPCIONES COMO EN LA ZCL_SLQ_02






  ENDMETHOD.
ENDCLASS.
