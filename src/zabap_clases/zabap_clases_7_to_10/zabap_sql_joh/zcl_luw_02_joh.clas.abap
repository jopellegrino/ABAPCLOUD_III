CLASS zcl_luw_02_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LUW_02_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*LUW
*UPDATE
*COMMIT WORK
*ROLLBACK* SOLO CANCELA HASTA DONDE LLEGA EL COMMIT WORK

*    """""COMMIT WORK (EFECTUA LOS CAMBIOS, CIERRA LA LUW)

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

      COMMIT WORK.                        """""""""""ESTO HACE QUE SE CIERRE LA LUW, Y POR ENDE NO SE PUEDE YA DESACER LOS CAMBIOS REALIZADOS HASTA AQUI, OSEA SE ACTUALIZO LA BBDD A EUR

      SELECT SINGLE FROM zcarrier_joh                "TRAE LOS DATOS PARA VER SI ACTUALIZO
               FIELDS *
               WHERE carrier_id = 'AA'               "COMO ES KEY TRAE UN SINGLE ROW
               INTO @ls_airline.                     "SE GUARDA EN UNA STRUC.


      IF sy-subrc = 0.                                                         "VERIFICA CORRECTO SELECT FROM
        out->write( |Campo Actualizado: { ls_airline-currency_code } | ).      "IMPRIME LA ACTUALIZACION VOLCADA EN LA STRUC.
      ENDIF.                                                                   "COMO EXISTE UN ROLLBACK EL VALOR AQUI IMPRESO REALMENTE NO SE COLOCO EN LA BBDD

    ENDIF.

    ROLLBACK WORK.                                   "DEVUELVE TODOS LOS CAMBIOS PRODUCIDOS EN ESTA LUW

  ENDMETHOD.
ENDCLASS.
