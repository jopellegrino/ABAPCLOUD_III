CLASS zcl_inv_data_gen_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

    CONSTANTS: c_pay       TYPE c LENGTH 1 VALUE 'P',
               c_unpayed   TYPE c LENGTH 1 VALUE 'U',
               c_overdue   TYPE c LENGTH 1 VALUE 'O',
               c_cancelled TYPE c LENGTH 1 VALUE 'C',
               c_posted    TYPE c LENGTH 1 VALUE 'X'.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_inv_data_gen_joh IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DELETE FROM zdbt_invoice_joh. "MUCHO CUIDADO ELIMINA TODOS LOS REGISTROS DE BBDD

    MODIFY zdbt_invoice_joh FROM TABLE @( VALUE #( ( invoice_id = '1'
                                                     company_cod = '1010'
                                                     customer  = 'Coca-Cola'
                                                     status     = c_pay
                                                     created_by = cl_abap_context_info=>get_user_technical_name(  ) )

                                                   ( invoice_id = '2'
                                                     company_cod = '2020'
                                                     customer  = 'Pepsi-Cola'
                                                     status     = c_overdue
                                                     created_by = cl_abap_context_info=>get_user_technical_name(  ) )

                                                   ( invoice_id = '3'
                                                     company_cod = '2030'
                                                     customer  = 'Mercadona'
                                                     status     = c_posted
                                                     created_by = 'CB9999999921' )

                                                   ( invoice_id = '4'
                                                     company_cod = '5050'
                                                     customer  = 'GADIS'
                                                     status     = c_cancelled
                                                     created_by = 'CB9999999222' )           ) ).

    IF sy-subrc = 0.    "VERIFICA QUE SE HIZO EL MODIFY CORRECTAMENTE
      out->write( |{ sy-dbcnt } Registros afectados| ). "CONTADOR DE REGISTROS AFECTADOS EN BBDD
    ENDIF.

  ENDMETHOD.

ENDCLASS.
