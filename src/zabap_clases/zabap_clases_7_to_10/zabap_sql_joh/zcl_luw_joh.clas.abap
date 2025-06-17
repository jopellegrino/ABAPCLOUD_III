CLASS zcl_luw_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_luw_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    """""DEVUELVE LOS CAMBIOS REALIZADOS EN UNA LUW

    SELECT SINGLE FROM zcarrier_joh                "TRAE LOS DATOS ANTES DE LA ACTUALIZACION
               FIELDS *
               WHERE carrier_id = 'AA'
               INTO @DATA(ls_airline).

    IF sy-subrc = 0.
      out->write( |Campo ANTES de Actualizacion: { ls_airline-currency_code } | ).
    ENDIF.


    UPDATE zcarrier_joh                     "ACTUALIZA LOS DATOS EN LA BBDD
       SET currency_code = 'EUR'
       WHERE carrier_id = 'AA'.

    IF sy-subrc = 0.                                 "VERIFICACION DE ACTUALIZACION

      SELECT SINGLE FROM zcarrier_joh                "TRAE LOS DATOS PARA VER SI ACTUALIZO
               FIELDS *
               WHERE carrier_id = 'AA'               "COMO ES KEY TRAE UN SINGLE ROW
               INTO @ls_airline.                     "SE GUARDA EN UNA STRUC.


      IF sy-subrc = 0.                               "VERIFICA CORRECTO SELECT FROM
        out->write( |Campo Actualizado: { ls_airline-currency_code } | ).      "IMPRIME LA ACTUALIZACION VOLCADA EN LA STRUC.
      ENDIF.

    ENDIF.

    ROLLBACK WORK.                                   "DEVUELVE TODOS LOS CAMBIOS PRODUCIDOS EN ESTA LUW

  ENDMETHOD.
ENDCLASS.
