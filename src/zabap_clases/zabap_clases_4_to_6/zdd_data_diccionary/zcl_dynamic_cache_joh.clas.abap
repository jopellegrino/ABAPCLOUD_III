CLASS zcl_dynamic_cache_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_dynamic_cache_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*   """"""CACHE DE UN QUERY DE UNA TABLA DE BBDD CON UNA AGREGACION Y AGRUPACION

    GET TIME STAMP FIELD DATA(lv_timestamp_begin).

    SELECT FROM zdbt_invoice_joh          "PARA USAR EL CACHE EL SELECT FROM DEBE TENER LAS MISMAS CONDICIONES DEL OBJETO DE CACHE
        FIELDS  company_cod,              "ESTA QUERY AGRUPA POR ESTOS CAMPOS, Y SUMA LOS MONTOS POR ELLOS
        currency_key,
        SUM( amount ) AS TotalAmount  "ES POSIBLE COLOCAR UN ALIAS
 GROUP BY company_cod, currency_key
 INTO TABLE @DATA(lt_invoices_sum).

    GET TIME STAMP FIELD DATA(lv_timestamp_end).
    DATA(lv_dif_sec) = cl_abap_tstmp=>subtract(  EXPORTING tstmp1 = lv_timestamp_END
                                                          tstmp2 = lv_timestamp_begin   ). "DEVUELVE EN SEGUNDOS LA RESTA DE DOS TIMESTAMPS


    IF sy-subcs = 0.               "NUMERO DE REGISTROS DE LA TABLA QUE RESULTO DE LA QUERY
      out->write( |Number of records { Lines( lt_invoices_sum ) }|   ).
      out->write( lt_invoices_sum ).
    ENDIF.



    out->write( |Total time: { lv_dif_sec } | ).

  ENDMETHOD.
ENDCLASS.
