CLASS zcl_04_tipo_referenciado DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_04_tipo_referenciado IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lvr_int    TYPE REF TO i,        "REFERENCIA UN TIPO DE DATO ELEMENTAL
          lvr_string TYPE REF TO string.

    DATA lvr_ddic_tab TYPE REF TO /dmo/airport. "REFERENCIA A UNA TABLA DE DATOS DEL STAND DE SAP

    DATA lvr_int2 LIKE lvr_int. "REFERENCIA A UNA REFERENCIA

    "************************************************************

    TYPES: ltyr_int TYPE REF TO i. " REFERENCIA DE UN TIPO REFERENCIADO CREACION Y DECLARACION

    DATA lvr_int3 TYPE ltyr_int.


    DATA lt_itab TYPE TABLE OF REF TO /dmo/airport. "REFERENCIA A UNA TABLA DE SAP


    DATA lo_ref TYPE REF TO zcl_02_tipos_de_datos. "REFERENCIA A UNA CLASE GLOBAL

  ENDMETHOD.
ENDCLASS.
