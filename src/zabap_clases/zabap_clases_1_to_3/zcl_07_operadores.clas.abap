CLASS zcl_07_operadores DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_07_OPERADORES IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_num_a     TYPE i VALUE 10,
          lv_num_b     TYPE i VALUE 15,
          lv_num_total TYPE p LENGTH 6 DECIMALS 2.


*    "OPERACION SUMA
*    "+
*    lv_num_total =  lv_num_a + lv_num_b.          "FORMA 1
*
*    out->write( |Number a: { lv_num_a } Number b: { lv_num_b } Number Total { lv_num_total } | ).
*
*    "ADD
*    ADD 5 TO lv_num_total.                        " FORMA  2, NO ACONSEJADO
*
*    out->write( |Total: { lv_num_total } | ).
*
*    " +=
*    lv_num_total += 5.                            "FORMA 3
*
*    out->write( |Total: { lv_num_total } | ).
*
*    CLEAR lv_num_total.  "LIMPIAR VARIABLE
*
*    out->write( |Total: { lv_num_total } | ).



**************RESTA

*    lv_num_total = lv_num_a - lv_num_b.         "FORMA 1
*
*    out->write( |Total: { lv_num_total } | ).
*
*    lv_num_total = lv_num_a - 1.                "FORMA 2
*
*    out->write( |Total: { lv_num_total } | ).
*
*    SUBTRACT 2 FROM lv_num_total.               "FORMA ANTIGUA
*
*    out->write( |Total: { lv_num_total } | ).



********MULTIPLICACION*****************

*    lv_num_total = lv_num_a * lv_num_b. "FORMA 1
*
*    out->write( |Total: { lv_num_total } | ).
*
*    MULTIPLY lv_num_total BY 5.          "FORMA ANTIGUA
*
*    out->write( |Total: { lv_num_total } | ).
*
*    lv_num_total = lv_num_total * 2.
*
*    out->write( |Total: { lv_num_total } | ).
*


*    "DIVISION
*
    lv_num_a = 9.
    lv_num_b = 4.
*
*    lv_num_total = lv_num_a / lv_num_b.     "DIVISION INCLUYENDO RESTO
*
*    out->write( |Total: { lv_num_total } | ).
*
*    lv_num_total = lv_num_a DIV lv_num_b.    "DIVISION SIN RESTO
*
*    out->write( |Total: { lv_num_total } | ).
*
*    lv_num_total = lv_num_a MOD lv_num_b.    "MOD (RESIDUO)
*
*    out->write( |Total: { lv_num_total } | ).

*    "EXPONENCIACION
*
*    lv_num_a = lv_num_a ** 2.          "PRIMERA FORMA
*    out->write( |{ lv_num_a } | ).
*    CLEAR lv_num_a.
*
*    lv_num_a = 3.
    DATA(lv_exp) = 3.
*    lv_num_a = lv_num_a ** lv_exp.
*    out->write( |{ lv_num_a } | ).
*
*    lv_exp = 3.
*    lv_num_a = 5.
*    DATA(result) = ipow( base = lv_num_a exp = lv_exp  ). "SEGUNDA FORMA
*    out->write( |{ result } | ).


    "RAIZ CUADRADA (SQRT)
    lv_exp = 3.
    lv_num_a = 5.

    lv_num_a = sqrt( 25 ).
    out->write( |{ lv_num_a } | ).


  ENDMETHOD.
ENDCLASS.
