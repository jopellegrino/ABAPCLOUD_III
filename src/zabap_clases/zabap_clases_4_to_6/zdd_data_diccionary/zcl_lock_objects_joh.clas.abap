CLASS zcl_lock_objects_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    CONSTANTS: c_pay       TYPE c LENGTH 1 VALUE 'P',
               c_unpayed   TYPE c LENGTH 1 VALUE 'U',
               c_overdue   TYPE c LENGTH 1 VALUE 'O',
               c_cancelled TYPE c LENGTH 1 VALUE 'C',
               c_posted    TYPE c LENGTH 1 VALUE 'X'.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lock_objects_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.



*    """""SOLICITAR BLOQUEO (NOTA USAR F2 PARA OBTENER

    out->write( |User has started the bussiness process| ).   "INICIO DEL BLOQUEO


*   """""PRIMERO, OBTENER INSTANCIA Y CAPTURARLA EN UNA VAR

    TRY. "PARA CAPTURAR LA POSIBLE EXCEPCION

        DATA(lo_lock_obj) = cl_abap_lock_object_factory=>get_instance(     ""CLASE, QUE PERMITE TRAER UNA INSTANCIA LLAMANDO AL METODO GET INSTANCE, SE COLOCA UNA DECLARACION PARA RECUPERAR LUEGO LA INSTANCIA
          EXPORTING                              "CTRL+SPACE Y LUEGO SHIFT+ENTER PARA INSERTAR TODA ESTA FIRMA
            iv_name = 'EZ_INV_JOH'   ).            "OBJETO DE BLOQUEO


      CATCH cx_abap_lock_failure.                       "PARA CAPTURAR LA POSIBLE EXCEPCION
        out->write( |Lock Object instance not created| ).
        RETURN.                                         "PARA SALIR PORQUE NO TIENE SENTIDO SEGUIR
    ENDTRY.                                             "PARA CAPTURAR LA POSIBLE EXCEPCION



*   """""SEG. PARAMETROS QUE SOLICITAN BLOQUEO
    DATA Lt_parameter TYPE if_abap_lock_object=>tt_parameter. "ES UNA TABLA DE PARAMETROS PORQUE SE BLOQUEN MULTIPLES REGISTROS EN LA MISMA SOLICITUD, ESTE CASO SON MULTIPLES QUE FORMAN LA KEY

    Lt_parameter = VALUE #( ( name = 'INVOICE_ID'
                              value = REF #( '100' ) )      "EL VALUE SE TIENE QUE CONVERTIR A REF PORQUE ES EL TIPO DE ESE CAMPO DE LA TABLA tt_parameter CON CTRL+CLICK EN LA TABLA LO VES

                              ( name = 'company_cod'
                              value = REF #( '1010' ) )  ).

    TRY.
        lo_lock_obj->enqueue(                      "USAR F2 SOBRE EL METODO PARA VER CUAL ITPARAMETERLUEGO DE OBTENER LA INSTANCIA DE BLOQUEO, VIENE LA SOLICITUD DE BLOQUEO
        it_parameter  =  Lt_parameter ).            "LOS PARAMETROS QUE SON CLAVE EN LA TABLA BLOQUEADA, SIN MANDANTE

      CATCH cx_abap_foreign_lock. "MENSAJES DEPENDIENDO DE LA EXCEPTION QUE APARECERA AL USER
        out->write( |Foreign Lock Exception| ).
      CATCH cx_abap_lock_failure.
        out->write( |Not possible to  write on database. Object is locked| ).
        RETURN.             "SALIR CUANDO EL REGISTRO ESTE BLOQUEADO, PORQUE POR AHORA NO ES POSIBLE SEGUIR
    ENDTRY.

    out->write( |Lock Object is active| ).


*   """""TERC. SIMULACION DE USARIO COLOCANDO DATOS
    DATA ls_invoice TYPE zdbt_invoice_joh.                    "ESTRUC. IGUAL A LA TABLA BLOQUEADA


    ls_invoice = VALUE #( invoice_id = '100'
                          company_cod = '1010'
                          Customer  = 'Joja-Cola'
                          status     = c_pay
                          Created_by = cl_abap_context_info=>get_user_technical_name(  )
                          amount = '2000'
                          currency_key = 'USD' ).

    MODIFY zdbt_invoice_joh FROM @ls_invoice.

    IF sy-subrc = 0.
      out->write( |Bussiness OBject was updated on the BBDD| ).
    ENDIF.

*    """""CUARTO LIBERAR BLOQUEO

    TRY.
        lo_lock_obj->dequeue( it_parameter  = Lt_parameter ). "CTRL+SPACE Y LUEGO Shift+Enter PARA APARECER TODOS LOS PARAMETROS DE ESTA LLAMADA

      CATCH cx_abap_lock_failure.
        out->write( |Lock object was NOT released | ).
    ENDTRY.

    out->write( |Lock object was released | ).

    WAIT UP TO 1 SECONDS. "ESPERA 1s

  ENDMETHOD.
ENDCLASS.
