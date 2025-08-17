CLASS zcl_sql_07_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SQL_07_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*   """""DELETE UN SOLO REGISTRO YA QUE USA UNA KEY EN EL WHERE

    DELETE FROM zcarrier_joh
    WHERE carrier_id = 'AA'.    "COLUMNA CLAVE, POR ELLO SOLO ELIMINA UN REGISTRO

    IF sy-subrc = 0.            "VERIFICACION DE ELIMINAR CORRECTA
      out->write( 'Record Deleted' ).
    ELSE.
      out->write( 'Record not availebe for deletion' ).
    ENDIF.


*   """""DELETE EN MULTIPLES REGISTROS YA QUE SE USA UN CAMPO CUALQUIERA


    DELETE FROM zcarrier_joh
    WHERE currency_code = 'USD'.    "COLUMNA NO CLAVE, POR ELLO SOLO MULTIPLES REGISTROS

    IF sy-subrc = 0.                "VERIFICACION DE ELIMINAR CORRECTA
      out->write( 'Record Deleted' ).
    ELSE.
      out->write( 'Record not availebe for deletion' ).
    ENDIF.



  ENDMETHOD.
ENDCLASS.
