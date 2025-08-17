CLASS zcl_gtt_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GTT_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*    """"""TABLA TEMPORAL DE BBDD (NO PERSISTEN LOS DATOS)

    "DATA lt_employees TYPE STANDARD TABLE OF zgtt_empl_joh.

    INSERT zgtt_empl_joh FROM TABLE @( VALUE #( ( employee_id = '00001'
                                                  first_name = 'John'
                                                  last_name = 'Smith'   ) ) ). "EMPUJAR LOS DATOS HIPOTETICAS PARA HACER LOS CALCULOS EN LA BBDD HANA


    SELECT FROM zgtt_empl_joh
           FIELDS *
           INTO TABLE @DATA(lt_employees).

    IF sy-subrc = 0.         "VERIFICA QUE SE INSERTO LOS REGISTROS Y LOS IMPRIME
      out->write( lt_employees ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

*    DELETE FROM zgtt_empl_joh. "ASEGURARSE DE ELIMINAR LOS DATOS DE LA TABLA TEMPORAL, PERO EN LA NEW VERSION NO ES NECESARIA
*    COMMINT WORK.
*    ROLLBACK WORK.

  ENDMETHOD.
ENDCLASS.
