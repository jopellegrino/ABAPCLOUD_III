CLASS zcl_lock_obj_univ_user DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lock_obj_univ_user IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "INSTANCIA DEL OBJETO DE BLOQUEO
    TRY.
        DATA(lo_lock_obj) = cl_abap_lock_object_factory=>get_instance( EXPORTING iv_name = 'EZ_UNIV_LOCK_JOH' ).

      CATCH cx_abap_lock_failure.
        out->write( |La instancia del objeto de bloqueo, no ha sido creada| ).
        RETURN.
    ENDTRY.


    "COMPONENTES Y VALOR A BLOQUEAR
    DATA Lt_parameter TYPE if_abap_lock_object=>tt_parameter.

    lt_parameter = VALUE #( ( name = 'CLIENT'
                              value = REF #( '100' ) )

                            ( name = 'SOC'
                             value = REF #( 'US03' ) ) ).

    TRY.
        lo_lock_obj->enqueue( it_parameter  = lt_parameter ).
      CATCH cx_abap_foreign_lock.
        out->write( | foreign lock Exception | ).
      CATCH cx_abap_lock_failure.
        out->write( | No es posible escribir en la base de datos, el objeto esta bloqueado| ).
        RETURN.
    ENDTRY.

    out->write( |El Bloqueo de objetos esta activo| ).


    "INSERTAR LOS DATOS

    DATA LS_zuniversity_joh TYPE zuniversity_joh.

    LS_zuniversity_joh = VALUE #( client       = '100'
                                  soc          = 'US03'
                                  course_price = '4000'
                                  currency     = 'USD'
                                  student_id   = '0000000005'
                                  first_name   = 'Pedro'
                                  last_name    = 'Jimenez'
                                  course_code  =  '02'            ).


    INSERT zuniversity_joh FROM @LS_zuniversity_joh.

    IF sy-subrc = 0.
      out->write( |Bussiness Object was updated on the BBDD| ).
    ELSE.
      out->write( |La el objeto bloqueado no pudo ser modificado| ).
    ENDIF.


    "LIBERAR BLOQUEO
    TRY.
        lo_lock_obj->dequeue( it_parameter = lt_parameter ).
      CATCH cx_abap_lock_failure.
        out->write( |El objeto no ha sido liberado| ).
    ENDTRY.



    "UTILIZACION DEL DYNAMIC CACHE EN CONSULTA SQL

    SELECT FROM zuniversity_joh
    FIELDS
    COUNT( * ) AS fields_count
    WHERE exercise = '2024'
    INTO @DATA(LT_dynamic_university_joh).


    out->write( |Fields: { LT_dynamic_university_joh }| ).

  ENDMETHOD.
ENDCLASS.
