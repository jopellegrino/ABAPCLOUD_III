CLASS zcl_05_objetos_variable DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_05_objetos_variable IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "*******************************************************************************************
    "VARIABLES

    DATA: lv_num1 TYPE i VALUE 10,
          lv_num2 TYPE i,
          lv_num3 TYPE i.

    lv_num2 = 15.

    lv_num3 = lv_num1 + lv_num2.



    "******************************************************************************************
    "CONSTANTES

    CONSTANTS: lc_num4   TYPE i VALUE 10,   "SE DEBEN DECLARAR Y DAR VALOR AL MISMO TIEMPO
               lc_num5   TYPE i VALUE 20,
               lc_string TYPE string VALUE 'ABAP'.

    lv_num3 = lc_num4.
    lv_num3 = lc_num5 + 5.


    "***************************************************************************************
    "LITERALES

    out->write( 'ABAB CLASS - ' ).
    out->write( |ESTUDIANTE 1| ).


    out->write( |Value 1 = { lv_num1 } Value 2 = { lv_num2 } Value 3 = { lv_num3  } |  ). "se coloca llaves para que lea el valor intriseco de la variable y no una cadena de caracteres


    "*******************************************************************************************
    "DECLARACION EN LINEA

    DATA(lv_invoice) = '01234XC'.
    DATA(lv_tax) = 1234.


  ENDMETHOD.
ENDCLASS.
