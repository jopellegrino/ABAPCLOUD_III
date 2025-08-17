CLASS zcl_lab_09_dinamicsql_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_09_DINAMICSQL_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  "1. ESPECIFICACION DIMANICA DE LA FUENTE, COLUMNAS Y FILTROS

    out->write( |SIN ITAB DINAMICA | ).

    TYPES: BEGIN OF ty_products,
             product_name TYPE c LENGTH 40,
             price        TYPE p LENGTH 10 DECIMALS 2,
           END OF ty_products.

    DATA: lt_products          TYPE STANDARD TABLE OF ty_products,
          lv_dynmic_dtsrc_name TYPE string,
          lv_dynmic_flds_name  TYPE string,
          lv_where_conditions  TYPE string.


    lv_dynmic_dtsrc_name = 'zproducts_joh'.


    IF lv_dynmic_dtsrc_name EQ 'zproducts_joh'.
      lv_dynmic_flds_name = |product_name, price|.
      lv_where_conditions = |price GE 100|.
    ELSE.
      lv_dynmic_flds_name = |product_name, price|.
      lv_where_conditions = |price LE 100|.
    ENDIF.


    TRY.
        SELECT FROM (lv_dynmic_dtsrc_name)
        FIELDS (lv_dynmic_flds_name)
        WHERE (lv_where_conditions)
        INTO CORRESPONDING FIELDS OF TABLE @lt_products.

      CATCH cx_sy_dynamic_osql_syntax
        cx_sy_dynamic_osql_semantics
        cx_sy_dynamic_osql_error      INTO DATA(lx_dynamic_osql).
        out->write( lx_dynamic_osql->get_text(  ) ).
        RETURN.
    ENDTRY.


    IF sy-subrc = 0.
      out->write( |Lines of table: { lines( lt_products ) }| ).
      out->write( lt_products ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.
    out->write( | | ).

*  "PROGRAMACION DINAMICA PARA ABAP SQL

    out->write( |TODO DINAMICO | ).

    DATA lo_generic_data TYPE REF TO data.
    FIELD-SYMBOLS <lt_itab> TYPE STANDARD TABLE.



    lv_dynmic_dtsrc_name = 'zproducts_joh'.


    IF lv_dynmic_dtsrc_name EQ 'zproducts_joh'.
      lv_dynmic_flds_name = |product_name, price|.
      lv_where_conditions = |price GE 100|.
    ELSE.
      lv_dynmic_flds_name = |product_name, price|.
      lv_where_conditions = |price LE 100|.
    ENDIF.


    TRY.

        DATA(lo_comp_table) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( lv_dynmic_dtsrc_name ) )->get_components(  ).

        DATA(lo_struc_type) = cl_abap_structdescr=>create( lo_comp_table ).

        DATA(lo_table_type) = cl_abap_tabledescr=>create( lo_struc_type ).

        CREATE DATA lo_generic_data TYPE HANDLE lo_table_type.

        ASSIGN lo_generic_data->* TO <lt_itab>.




        SELECT FROM (lv_dynmic_dtsrc_name)
        FIELDS (lv_dynmic_flds_name)
        WHERE (lv_where_conditions)
        INTO CORRESPONDING FIELDS OF TABLE @<lt_itab>.

      CATCH cx_sy_dynamic_osql_syntax
        cx_sy_dynamic_osql_semantics
        cx_sy_dynamic_osql_error      INTO DATA(lx_dynamic_osql2).
        out->write( lx_dynamic_osql2->get_text(  ) ).
        RETURN.
    ENDTRY.


    IF sy-subrc = 0.
      out->write( |Lines of table: { lines( <lt_itab> ) }| ).
      out->write( <lt_itab> ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.


  ENDMETHOD.
ENDCLASS.
