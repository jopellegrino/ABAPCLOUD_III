CLASS zcl_lab_01_ins_sql_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_01_ins_sql_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "INSERTAR UN REGISTROS USANDO UNA STRUC.

    DATA ls_products TYPE zproducts_joh.

*    ls_products = VALUE #( product_id   = 00000001
*                           product_name = 'Joja-Cola'
*                           category_id  = 00000010
*                           quantity     = 10
*                           price        = '10.33'   ).
*
*    INSERT  zproducts_joh FROM @ls_products.
*
*    IF sy-subrc = 0.
*      out->write( 'Se ha insertado correctamente el registro' ).
*    ELSE.
*      out->write( 'NO se ha realizado la insercion correctamente' ).
*    ENDIF.


    "INSETAR MULTIPLES REGISTROS USANDO UNA ITAB
    DELETE FROM zproducts_joh.

    DATA lt_products TYPE STANDARD TABLE OF zproducts_joh.

    lt_products = VALUE #(  ( product_id   = 00000002
                              product_name = 'Nike One'
                              category_id  = 00000002
                              quantity     = 11
                              price        = '200.33'  )

                               ( product_id  = 00000005
                              product_name = 'Pepsi-Cola'
                              category_id  = 00000002
                              quantity     = 3
                              price        = '77.33'    )

                             ( product_id  = 00000063
                              product_name = 'Coca-Cola'
                              category_id  = 00000220
                              quantity     = 55
                              price        = '23.00'    )

                              ( product_id = 00000043
                              product_name = 'Pegaloca'
                              category_id  = 00000550
                              quantity     = 22
                              price        = '13.33'    )

                              ( product_id = 00000015
                              product_name = 'SSD Kingston R10'
                              category_id  = 00000330
                              quantity     = 33
                              price        = '100.33'    )  ) .

    INSERT zproducts_joh FROM TABLE @lt_products.

    IF sy-subrc = 0.
      out->write( |Se han insertado correctamente: { sy-dbcnt } registros| ).
    ELSE.
      out->write( 'NO se ha realizado la insercion correctamente' ).
    ENDIF.

    "INSERTAR REGISTROS CON TRATAMIENTO DE EXCEPCIONES

    lt_products = VALUE #( ( product_id   = 00000001
                              product_name = 'Moja-Cola'
                              category_id  = 00000110
                              quantity     = 11
                              price        = '9.33'  ) ).

    TRY.

        INSERT zproducts_joh FROM TABLE @lt_products.

      CATCH cx_sy_open_sql_db INTO DATA(lx_duplicate_key).
        out->write( lx_duplicate_key->get_text(  ) ).
        RETURN.

    ENDTRY.

    IF sy-subrc = 0.
      out->write( |Se han insertado correctamente: { sy-dbcnt } registros| ).
    ELSE.
      out->write( 'NO se ha realizado la insercion correctamente' ).
    ENDIF.


    "FORMA DE SOLUCION
    TRY.
        INSERT zproducts_joh FROM TABLE @( VALUE #( ( product_id = 2
        product_name = 'ASUS'
        category_id = 2
        quantity = 1
        price = '200.05' ) ) ).
        IF sy-subrc EQ 0.
          out->write( |{ sy-dbcnt } records were added| ).
        ENDIF.
      CATCH cx_sy_open_sql_db INTO DATA(lx_error).
        out->write( lx_error->get_text( ) ).
        RETURN.
    ENDTRY.


  ENDMETHOD.
ENDCLASS.
