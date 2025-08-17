CLASS zcl_lab_07_filtersql_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_07_FILTERSQL_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  "OPERADORES RELACIONALES

*    SELECT FROM zproducts_joh
*    FIELDS product_name, price
*    WHERE price GE 100
*    INTO TABLE @DATA(lt_products).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_products ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*    "2. BETWEEN

*    SELECT FROM zproducts_joh
*    FIELDS product_name, price
*    WHERE price BETWEEN 100 AND 1000
*   INTO TABLE @DATA(lt_products2).

*    IF sy-subrc EQ 0.
*      out->write( lt_products2 ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.

*    "3. CARACTERES COMODINES CON LIKE
*
*    DATA lv_search_criteria TYPE string VALUE '%s%'.
*    DATA lv_search_criteria2 TYPE string VALUE 's%'.
*    DATA lv_search_criteria3 TYPE string VALUE '%s'.
*
*    SELECT FROM zproducts_joh
*        FIELDS product_name, price
*    WHERE product_name LIKE @lv_search_criteria  OR
*          product_name LIKE @lv_search_criteria2 OR
*          product_name LIKE @lv_search_criteria3
*    INTO TABLE @DATA(lt_products3).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_products3 ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*   4. CARACTERES DE ESCAPE

*    SELECT FROM zproducts_joh
*    FIELDS *
*    INTO TABLE @DATA(LT_products).
*
*    IF sy-subrc = 0.
*
*      LOOP AT LT_products ASSIGNING FIELD-SYMBOL(<lfs_products>).
*          <lfs_products>-product_name = |%: { <lfs_products>-product_name } |.
*      ENDLOOP.
*
*      UPDATE zproducts_joh FROM TABLE @LT_products.
*
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.

*    CONSTANTS cv_escape TYPE c LENGTH 1 VALUE '#'.
*
*    SELECT FROM zproducts_joh
*    FIELDS *
*    WHERE product_name LIKE '#%%' ESCAPE @cv_escape
*    INTO TABLE @DATA(LT_products).
*
*    IF sy-subrc EQ 0.
*      out->write( LT_products ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.

*   "IN

*    SELECT FROM zproducts_joh
*    FIELDS *
*    WHERE category_id IN ( '110', '2' )
*    INTO TABLE @DATA(lt_products2).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_products2 ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*    IN TABLA DE RANGOS

*    DATA ltr_categoryid TYPE RANGE OF int8.
*
*    ltr_categoryid = VALUE #( ( sign   = 'I'
*                                option = 'EQ'
*                                low    = 2   )
*                              ( sign   = 'I'
*                                option = 'EQ'
*                                low    = 110   ) ).
*
*    SELECT FROM zproducts_joh
*    FIELDS product_name,
*           category_id
*    WHERE category_id IN @ltr_categoryid
*    INTO TABLE @DATA(lt_products4).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_products4 ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.


*   "NULL

*    SELECT FROM zproducts_joh
*    FIELDS *
*    WHERE product_name IS NOT NULL
*    INTO TABLE @DATA(lt_products5).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_products5 ).
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.

*   "8. AND/OR/NOT

    SELECT FROM zproducts_joh
    FIELDS product_name,
           category_id,
           price
    WHERE ( category_id EQ 10 OR category_id EQ 2 )
      AND ( price GE 100 )
    INTO TABLE @DATA(lt_productos6).

    IF sy-subrc EQ 0.
      out->write( lt_productos6 ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
