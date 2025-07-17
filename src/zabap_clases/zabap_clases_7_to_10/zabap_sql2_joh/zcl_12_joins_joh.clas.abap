CLASS zcl_12_joins_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_12_joins_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TYPES: BEGIN OF ty_structure, "COLUMNAS DE LAS DOS FUENTE
             id1          TYPE c LENGTH 2,
             id2          TYPE c LENGTH 2,
             name_1       TYPE c LENGTH 10,
             name_2       TYPE c LENGTH 10,
             datasource_1 TYPE c LENGTH 15,
             datasource_2 TYPE c LENGTH 15,
           END OF ty_structure,
           type_table TYPE TABLE OF ty_structure.







  ENDMETHOD.
ENDCLASS.
