CLASS zcl_lab_02_updatesql_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_lab_02_updatesql_joh IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "ACTUALIZAR UN REGISTRO
    DATA ls_products TYPE zproducts_joh.

    SELECT SINGLE FROM zproducts_joh
           FIELDS *
           WHERE product_id = 1
        INTO @ls_products.

    ls_products-quantity = 75.
    ls_products-price = '899.99'.

    UPDATE zproducts_joh FROM @ls_products.

    IF sy-subrc = 0.
      out->write( 'El registro fue actualizado correctamente' ).
    ELSE.
      out->write( 'El registro NO se actualizo correctamente' ).
    ENDIF.

    "FORMA SOLUCION
    UPDATE zproducts_joh FROM @( VALUE #( product_id   = 1
                                          product_name = 'Lenovo'
                                          category_id  = 2
                                          quantity     = 75
                                          price        = '899.99'       ) ).

    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } records were updated| ).
    ENDIF.

    "ACTUALIZAR MULTIPLES REGISTROS

    SELECT FROM zproducts_joh
    FIELDS *
    WHERE category_id = 2
    INTO TABLE @DATA(lt_products).

    IF sy-subrc = 0.

      LOOP AT lt_products ASSIGNING FIELD-SYMBOL(<lfs_products>).
        <lfs_products>-quantity = '120'.
      ENDLOOP.

      UPDATE zproducts_joh FROM TABLE @lt_products.


      IF sy-subrc = 0.
        out->write( |Registros actualizados correctamente { sy-dbcnt }| ).
      ELSE.
        out->write( |No se ha actualizado el registro correctamente| ).
      ENDIF.


    ELSE.
      out->write( |El select a fallado| ).
    ENDIF.



    "ACTUALIZAR COLUMNAS

    UPDATE zproducts_joh
    SET price = '50'
    WHERE category_id = 2.

    IF sy-subrc = 0.
      out->write( |Registros actualizados correctamente { sy-dbcnt }| ).
    ELSE.
      out->write( |No se ha actualizado el registro correctamente| ).
    ENDIF.


    "ACTUALIZAR COLUMNAS

    UPDATE zproducts_joh
    SET price = price + 50
    WHERE product_id >= 1.

    IF sy-subrc = 0.
      out->write( |Registros actualizados correctamente { sy-dbcnt }| ).

      SELECT FROM zproducts_joh
      FIELDS *
      INTO TABLE @DATA(lt_product2).

      IF sy-subrc = 0.
        out->write( lt_product2 ).
      ENDIF.

    ELSE.
      out->write( |No se ha actualizado el registro correctamente| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
