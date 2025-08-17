CLASS zcl_lab_04_deletesql_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_04_DELETESQL_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "ELIMINAR UN REGISTRO

    "FORMA PROPIA
    DATA(ls_products) = VALUE zproducts_joh( product_id = 1 ).

    DELETE zproducts_joh FROM @ls_products.

    IF sy-subrc = 0.
      out->write( 'La eliminacion se realizo correctamente' ).
    ELSE.
      out->write( 'La eliminacion ha fallado' ).
    ENDIF.

    "FORMA DE SOLUCION
    DELETE zproducts_joh FROM @( VALUE #( product_id = 1 ) ).
    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } records were deleted| ).
    ENDIF.




    "ELIMINAR MULTIPLES REGISTROS

    SELECT FROM zproducts_joh
    FIELDS *
    WHERE product_id = 2 OR product_id = 3
    INTO TABLE @DATA(lT_products).

    IF sy-subrc = 0.

      DELETE zproducts_joh FROM TABLE @lT_products.

      IF sy-subrc = 0.
        out->write( 'La eliminacion se realizo correctamente' ).
      ELSE.
        out->write( 'La eliminacion ha fallado' ).
      ENDIF.

    ELSE.
      out->write( 'El SELECT no se realizo correctamente' ).
    ENDIF.


    "ELIMINAR REGISTROS USANDO FILTROS

    "FORMA PROPIA
    SELECT FROM zproducts_joh
    FIELDS *
    WHERE quantity > 100
    INTO TABLE @lT_products.

    IF sy-subrc = 0.

      DELETE zproducts_joh FROM TABLE @lT_products.

      IF sy-subrc = 0.
        out->write( |La eliminacion se realizo correctamente sobre { sy-dbcnt } | ).
      ELSE.
        out->write( 'La eliminacion ha fallado' ).
      ENDIF.

    ELSE.
      out->write( 'El SELECT no se realizo correctamente' ).
    ENDIF.

    "FORMA SOLUCION
    DELETE FROM zproducts_joh WHERE price GT 100.
    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } records were deleted| ).
    ENDIF.




  ENDMETHOD.
ENDCLASS.
