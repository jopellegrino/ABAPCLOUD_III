CLASS zcl_lab_08_sqlexpressions_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_08_SQLEXPRESSIONS_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*   1. min / max

    SELECT FROM zproducts_joh
    FIELDS MIN( price ) AS MinPrice,
    MAX( price ) AS MaxPrice
    INTO @DATA(ls_products).

    IF sy-subrc = 0.
      out->write( ls_products  ).
    ELSE.
      out->write( |NO DATA | ).
    ENDIF.


*    2. avg / sum

    SELECT FROM zproducts_joh
    FIELDS AVG( price ),
    SUM( price )
    INTO ( @DATA(lv_Avg_price), @DATA(lv_sum_price) ).

    IF sy-subrc = 0.
      out->write( |Precio promedio: { lv_Avg_price } Suma del precio: { lv_sum_price }  | ).
    ELSE.
      out->write( |NO DATA | ).
    ENDIF.


*    1. min / max (distinct)

    SELECT FROM zproducts_joh
    FIELDS MIN( DISTINCT price ) AS MinDisctPrice,
    MAX( DISTINCT price ) AS MaxDisctPrice
    INTO @DATA(ls_products2).

    IF sy-subrc = 0.
      out->write( ls_products2  ).
    ELSE.
      out->write( |NO DATA | ).
    ENDIF.


*    4. count

    SELECT FROM zproducts_joh
    FIELDS COUNT( * ) AS countAll
    INTO @DATA(lv_count_product).

    IF sy-subrc = 0.
      out->write( |Num. de productos: { lv_count_product } |  ).
    ELSE.
      out->write( |NO DATA | ).
    ENDIF.


*    5. group by y having

    SELECT FROM zproducts_joh
    FIELDS category_id,
    AVG( price ) AS Avgprice
    GROUP BY category_id, price HAVING price >= 70
    INTO TABLE @DATA(lt_group_having).

    IF sy-subrc = 0.
      out->write( lt_group_having  ).
    ELSE.
      out->write( |NO DATA | ).
    ENDIF.


*    6. order by y offset


    DATA: lv_page_numer       TYPE i VALUE 2,
          lv_records_per_page TYPE i VALUE 2.

    DATA gv_offset TYPE int8.

    gv_offset =  ( lv_page_numer - 1 ) * lv_records_per_page.

    SELECT FROM zproducts_joh
    FIELDS *
    ORDER BY price DESCENDING
    INTO TABLE @DATA(lt_products3)
    OFFSET @gv_offset
    UP TO @lv_records_per_page ROWS.


    IF sy-subrc = 0.
      out->write( lt_products3  ).
    ELSE.
      out->write( |NO DATA | ).
    ENDIF.







  ENDMETHOD.
ENDCLASS.
