CLASS zcl_lab_03_modifysql_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_03_MODIFYSQL_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "1. MODIFICAR UN REGISTRO

*    SELECT FROM zproducts_joh
*    FIELDS *
*    WHERE product_id = 1
*    INTO TABLE @DATA(lt_products).
*
*    IF sy-subrc = 0.
*
*      LOOP AT lt_products ASSIGNING FIELD-SYMBOL(<lfs_products>).
*        <lfs_products>-quantity = 60.
*        <lfs_products>-price = '850.99'.
*      ENDLOOP.
*
*      MODIFY zproducts_joh FROM TABLE @lt_products.
*
*      IF sy-subrc = 0.
*        out->write( |La modificacion se realizo correctamente sobre { sy-dbcnt } registros| ).
*      ELSE.
*        out->write( 'La modificacion no se pudo realizar' ).
*      ENDIF.
*
*    ELSE.
*      out->write( 'El SELECT no se realizo correctamente' ).
*    ENDIF.

    "2. MODIFICAR MULTIPLES REGISTROS

    SELECT FROM zproducts_joh
    FIELDS *
    WHERE product_id = '1'
    INTO TABLE @DATA(lt_products).

    IF sy-subrc = 0.


      LOOP AT lt_products ASSIGNING FIELD-SYMBOL(<lfs_products2>).
        <lfs_products2>-quantity = 90.

        IF <lfs_products2>-product_id = 1.
          APPEND VALUE #( product_id = 10
                          product_name = 'MSI'
                          category_id = <lfs_products2>-category_id
                          quantity = <lfs_products2>-quantity
                          price = <lfs_products2>-price                   ) TO lt_products.
        ENDIF.

      ENDLOOP.



      MODIFY zproducts_joh FROM TABLE @lt_products.

      IF sy-subrc = 0.
        out->write( |La modificacion se realizo correctamente sobre { sy-dbcnt } registros| ).
      ELSE.
        out->write( 'La modificacion no se pudo realizar' ).
      ENDIF.


    ELSE.
      out->write( 'El SELECT no se realizo correctamente' ).
    ENDIF.





  ENDMETHOD.
ENDCLASS.
