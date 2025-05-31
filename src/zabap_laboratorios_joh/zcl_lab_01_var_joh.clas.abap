CLASS zcl_lab_01_var_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_01_VAR_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    """1. TIPO DE DATOS ELEMENTALES
    DATA: mv_purchase_date TYPE d,
          mv_purchase_time TYPE t,
          mv_price         TYPE f,
          mv_tax           TYPE i,
          mv_increase      TYPE decfloat16,
          mv_discounts     TYPE decfloat34,

          mv_type          TYPE c LENGTH 10,
          mv_shipping      TYPE p LENGTH 8 DECIMALS 2,
          mv_id_code       TYPE n LENGTH 4,
          mv_qr_code       TYPE x LENGTH 5.

    mv_purchase_date = '20241016'.
    mv_purchase_time = '095416'.
    mv_price = '10.5'.
    mv_tax = 16.
    mv_increase = '20.5'.
    mv_discounts = '10.5'.

    mv_type = 'PC'.
    mv_shipping = '40.36'.
    mv_id_code = 1110.
    mv_qr_code = 'F5CF'.

    "2. TIPO DE DATOS COMPLEJOS

    TYPES: BEGIN OF mty_customer,
             id       TYPE i,
             customer TYPE c LENGTH 15,
             age      TYPE i,
           END OF mty_customer.

    DATA ls_customer TYPE mty_customer.

    ls_customer = VALUE #( id = 4444
                           customer = 'Carolina'
                           age = 35                    ).


    "3.TIPO DE DATOS DE REFERENCIA

    DATA: ms_employees TYPE TABLE OF REF TO /dmo/employee_hr,
          ls_employees TYPE /dmo/employee_hr.

    ls_employees = VALUE #( client = 123
                         employee = 123456
                         first_name  = 'Jose'
                         last_name = 'Ramirez'
                         salary = 49999
                         salary_currency = 'EUR'
                         manager = 123456789 ).


    "4.OBJETOS DE DATOS

    DATA mv_product TYPE String.
    DATA mv_bar_code TYPE xstring.

    mv_product = 'Lapto'.
    mv_bar_code = '12121121211'.


    "5.CONSTANTES

    CONSTANTS: mc_purchase_date            TYPE d VALUE '20241016',
               mc_purchase_time            TYPE t VALUE '095416',
               mc_price                    TYPE f VALUE '10.5',
               mc_tax                      TYPE i VALUE 16,
               mc_increase                 TYPE decfloat16 VALUE '20.5',
               mc_discounts                TYPE decfloat34 VALUE '10.5',

               mc_type                     TYPE c LENGTH 10 VALUE 'PC',
               mc_shipping                 TYPE p LENGTH 8 DECIMALS 2 VALUE '40.36',
               mc_id_code                  TYPE n LENGTH 4 VALUE '1110',
               mc_qr_code                  TYPE x LENGTH 5 VALUE 'F5CF',

               mc_customer_id              TYPE i VALUE 4444,
               mc_customer_cus             TYPE c LENGTH 15 VALUE 'Carolina',
               mc_age                      TYPE i VALUE 35,

               mc_employee_client          TYPE i VALUE 123,
               mc_employee                 TYPE i VALUE 123456,
               mc_employee_first_name      TYPE string VALUE 'Jose',
               mc_employee_last_name       TYPE string VALUE 'Ramirez',
               mc_employee_salary          TYPE i VALUE 49999,
               mc_employee_salary_currency TYPE string VALUE 'EUR',
               mc_employee_manager         TYPE i VALUE 123456789,

               mc_product                  TYPE String VALUE 'Lapto',
               mc_bar_code                 TYPE xstring VALUE '12121121211'.

    "6.DECLARACIONES EN LINEA

    DATA(lv_product) = mv_product.
    DATA(lv_bar_code) = mv_bar_code.



    "TIPO ELEMENTALES
    out->write( |Purchase Date:{ mv_purchase_date+6(2) }/{ mv_purchase_date+4(2) }/{ mv_purchase_date+0(4) } | ).
    out->write( |Purchase Time:{ mv_purchase_time+0(2) }:{ mv_purchase_time+2(2) }:{ mv_purchase_time+4(2) } | ).
    out->write( |Price:{ mv_price }  Tax:{ mv_tax }  Increase:{ mv_increase }  Discounts:{ mv_discounts } | ).
    out->write( |Type:{ mv_type } Shipping:{ mv_shipping } Id Code:{ mv_id_code } QR Code:{ mv_qr_code } | ).

    "OBJETOS DE DATOS
    out->write( |Ref-Product:{ lv_product } Ref-Bar Code:{ lv_bar_code } | ).

    "EN LINEA
    out->write( |Product:{ mv_product } Bar Code:{ mv_bar_code } | ).

    "TIPO COMPLEJO
    out->write( |Id:{ ls_customer-id } Customer:{ ls_customer-customer } Age:{ ls_customer-age }| ).

    "REFERENCIADO
    out->write( |First Name:{ ls_employees-first_name } Client:{ ls_employees-client } Employee:{ ls_employees-employee } | ).
    out->write( |Last Name:{ ls_employees-last_name }  Salary:{ ls_employees-salary }  | ).
    out->write( |Manager:{ ls_employees-manager }  Salary Currency:{ ls_employees-salary_currency } | ).

  ENDMETHOD.
ENDCLASS.
