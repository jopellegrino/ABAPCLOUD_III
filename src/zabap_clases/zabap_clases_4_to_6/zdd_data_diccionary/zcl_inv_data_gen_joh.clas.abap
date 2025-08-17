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



CLASS ZCL_INV_DATA_GEN_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    GET TIME STAMP FIELD DATA(lv_timestamp_begin).   "CAPTURA LA HORA DESDE ESE PUNTO (INICIO)

    DELETE FROM zdbt_invoice_joh. "MUCHO CUIDADO ELIMINA TODOS LOS REGISTROS DE BBDD

    DO 100000 TIMES.   "GENERA 10000 FACTURAS, POR INVOICE_ID PARA CADA COMPAÑIA

      MODIFY zdbt_invoice_joh FROM TABLE @( VALUE #( ( invoice_id   = sy-index
                                                       company_cod  = '1010'
                                                       customer     = 'Joja-Cola'
                                                       status       = c_pay
                                                       created_by   = cl_abap_context_info=>get_user_technical_name(  )
                                                       amount       = '1000'
                                                       currency_key = 'USD' )


                                                     ( invoice_id   = sy-index
                                                       company_cod  = '1020'
                                                       customer     = 'Consum'
                                                       status       = c_overdue
                                                       created_by   = cl_abap_context_info=>get_user_technical_name(  )
                                                       amount       = '1150'
                                                       currency_key = 'USD' )

                                                     ( invoice_id   = sy-index
                                                       company_cod  = '1030'
                                                       customer     = 'Farmatodo'
                                                       status       = c_posted
                                                       created_by   = 'CB999999411'
                                                       amount       = '1500'
                                                       currency_key = 'USD' )

                                                     ( invoice_id   = sy-index
                                                       company_cod  = '1040'
                                                       customer     = 'Farmacias SAAS'
                                                       status       = c_cancelled
                                                       created_by   = 'CB9999994722'
                                                       amount       = '1250'
                                                       currency_key = 'USD' )

                                                      ( invoice_id  = sy-index
                                                       company_cod  = '1050'
                                                       customer     = 'MercaJoja'
                                                       status       = c_posted
                                                       created_by   = 'CB999944442'
                                                       amount       = '1250'
                                                       currency_key = 'EUR'  ) ) ).
    ENDDO.

    GET TIME STAMP FIELD DATA(lv_timestamp_END).    "CAPTURA LA HORA AL FINALIZAR EL BUCLE

    DATA(lv_dif_sec) = cl_abap_tstmp=>subtract(  EXPORTING tstmp1 = lv_timestamp_END
                                                           tstmp2 = lv_timestamp_begin   ). "DEVUELVE EN SEGUNDOS LA RESTA DE DOS TIMESTAMPS

    out->write( |Total time: { lv_dif_sec } | ).

    IF sy-subrc = 0.    "VERIFICA QUE SE HIZO EL MODIFY CORRECTAMENTE
      out->write( |{ sy-dbcnt } Registros afectados| ). "CONTADOR DE REGISTROS AFECTADOS EN BBDD
    ENDIF.

  ENDMETHOD.
ENDCLASS.
