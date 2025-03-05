CLASS zcl_lab_02_arithmetic_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_02_arithmetic_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "1. SUMA / SENTENCIA ADD
    DATA: lv_base_rate            TYPE i VALUE 20,
          lv_corp_area_rate       TYPE i VALUE 10,
          lv_medical_service_rate TYPE i VALUE 15,
          lv_total_rate           TYPE i.

    lv_total_rate = lv_base_rate + lv_corp_area_rate + lv_medical_service_rate.

    ADD 5 TO lv_total_rate.

    out->write(  | Total Add Rate: { lv_total_rate }| ).


    "2. RESTA / SENTENCIA SUBTRACT
    DATA: lv_maintenance_rate TYPE i VALUE 30,
          lv_margin_rate      TYPE i VALUE 10,
          lv_base_rate2       TYPE i.

    lv_base_rate2 = lv_maintenance_rate - lv_margin_rate.

    SUBTRACT 4 FROM lv_base_rate2.

    out->write(  | Total Subtract Rate: { lv_base_rate2 }| ).


    "3. MULTIPLICACION / SENTENCIA MULTIPLY
    DATA: lv_package_weight TYPE i VALUE 2,
          lv_cost_per_kg    TYPE i VALUE 3,
          lv_multi_rate     TYPE i.

    lv_multi_rate =  lv_package_weight *  lv_cost_per_kg.

    MULTIPLY lv_multi_rate BY 2.


    out->write(  | Total Multiply Rate: { lv_multi_rate }| ).


    "4. DIVISION / SENTENCIA DIVIDE
    DATA: lv_total_weight TYPE i VALUE 38,
          lv_num_packages TYPE i VALUE 4,
          lv_applied_rate TYPE p LENGTH 8 DECIMALS 2.

    lv_applied_rate = lv_total_weight / lv_num_packages.

    DIVIDE lv_applied_rate BY 3.

    out->write(  | Total Applied Rate: { lv_applied_rate }| ).


    "5. DIVISION SIN RESTO / SENTENCIA DIV
    DATA: lv_total_cost         TYPE i VALUE 17,
          lv_discount_threshold TYPE i VALUE 4,
          lv_result             TYPE p LENGTH 4 DECIMALS 2.

    lv_result = lv_total_cost DIV lv_discount_threshold.

    out->write(  | Result Cost: { lv_result }| ).


    "6. RESTO (RESIDUO) DE DIVISION / SENTENCIA MOD
    DATA: lv_total_cost2         TYPE i VALUE 19,
          lv_discount_threshold2 TYPE i VALUE 4,
          lv_remainder           TYPE p LENGTH 4 DECIMALS 2.

    lv_remainder = lv_total_cost2 MOD lv_discount_threshold2.
    out->write(  | Resto: { lv_remainder }| ).


    "7. EXPONENCIACION
    DATA: lv_weight TYPE i VALUE 5,
          lv_expo   TYPE i.

    lv_expo = ipow( base = lv_weight exp = 2 ).
    out->write(  | Exponenciacion: { lv_expo }| ).


    "8. RAIZ CUADRADA
    DATA: lv_square_root TYPE i.

    lv_square_root = sqrt( lv_expo ).
    out->write(  | Raiz Cuadrada: { lv_square_root }| ).



  ENDMETHOD.
ENDCLASS.
