CLASS zcl_lab_05_commitsql_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_05_commitsql_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "COMMIT WORK

*    INSERT zproducts_joh FROM TABLE @( VALUE #( ( product_id   = 20
*                                                  product_name = 'ONE PLUS'
*                                                  category_id  = 10
*                                                  quantity     = 200
*                                                  price        = '25.99'            ) ) ).
*
*    IF sy-subrc = 0.
*      out->write( |Se han insertado correctamente { sy-dbcnt } registros| ).
*    ELSE.
*      out->write( |La insercion ha fallado| ).
*    ENDIF.

*    commit WORK.
    SELECT FROM zproducts_joh
    FIELDS *
    INTO TABLE @DATA(lT_prodcut_rback).



    out->write( data = lT_prodcut_rback name = 'IMPRESION ANTES DE ACTUALIZAR BBDD' ).

    UPDATE zproducts_joh FROM TABLE @( VALUE #( ( product_id   = 63
                                                  product_name = 'Coca-Cola'
                                                  category_id  = 220
                                                  quantity     = 55
                                                  price        = '20.99'            ) ) ).


    SELECT FROM zproducts_joh
    FIELDS *
    INTO TABLE @lT_prodcut_rback.

    out->write( data = lT_prodcut_rback name = 'IMPRESION DESPUES DE ACTUALIZAR BBDD' ).

    ROLLBACK WORK.

    SELECT FROM zproducts_joh
    FIELDS *
    INTO TABLE @lT_prodcut_rback.

    out->write( data = lT_prodcut_rback name = 'IMPRESION DESPUES DE ROLLBACK WORK BBDD' ).







  ENDMETHOD.
ENDCLASS.
