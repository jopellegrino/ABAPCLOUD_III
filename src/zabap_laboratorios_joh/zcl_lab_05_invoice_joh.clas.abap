CLASS zcl_lab_05_invoice_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_05_invoice_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: mv_exercise     TYPE n LENGTH 4 VALUE 123,
          mv_invoice_no   TYPE n LENGTH 8 VALUE 45678910,
          mv_invoice_code TYPE string.

    "1.CONCATENACIONES

    CONCATENATE mv_exercise mv_invoice_no INTO mv_invoice_code SEPARATED BY '/'.
    out->write( |Concatenacion de las variables MV_EXERCISE y MV_EXERCISE: { mv_invoice_code } | ).


    "2. CONCATENACIONES DE LINEAS DE TABLAS

    "SELECT FROM zemp_logali
    "FIELDS id, client
    "INTO TABLE @DATA(lt_employees).

    "DATA(lv_string_itab) = concat_lines_of( table = lt_employees sep = ` ` ).
    "out->write( |Conc. de datos de tabla: { lv_string_itab }| ).


    "3.CONDENSACION

    DATA: mv_case1 TYPE string VALUE 'Sales invoice with     status in process',
          mv_case2 TYPE string VALUE '***ABAP*Cloud***'.

    CONDENSE mv_case1.
    out->write( |Eliminacion de los espacios inncesarios de la Variblae MV_CASE1: { mv_case1 } | ).

    mv_case2 = replace( val = mv_case2 sub = '*' with = ` ` occ = 0 ).
    CONDENSE mv_case2.
    out->write( |Eliminacion del caracter '*' de la Variblae MV_CASE2: { mv_case2 } | ).

    "4.SPLIT

    DATA: mv_data        TYPE string VALUE '0001111111;LOGALIGROUP;2024',
          mv_id_customer TYPE string,
          mv_customer    TYPE string,
          mv_year        TYPE string.

    SPLIT mv_data AT ';' INTO mv_id_customer
                              mv_customer
                              mv_year.

    out->write( |ID CUSTOMER: { mv_id_customer }  CUSTOMER: { mv_customer }  YEAR: { mv_customer }| ).


    "5. SHIFT

    DATA mv_invoice_num TYPE string VALUE '2015ABCD'.

    out->write( |Variable Inicial MV_INVOICE_NUM: { mv_invoice_num } | ).

    SHIFT mv_invoice_num BY 2 PLACES.
    mv_invoice_num = shift_right( val = mv_invoice_num places = 2 ).

    out->write( |Eliminacion de (2) caracteres al inicio y final de MV_INVOICE_NUM: { mv_invoice_num } | ).


    "6. FUNCIONES STRLEN Y NUMOFCHAR

    DATA: mv_response TYPE string VALUE ' Generating Invoice ',
          mv_count    TYPE string.

    mv_count = strlen( mv_response ).
    out->write( |La cantidad de caracteres con strlen de la variable mv_response es: { mv_count } | ).

    mv_count = numofchar( mv_response ).
    out->write( |La cantidad de caracteres con numofchar de la variable mv_response es: { mv_count } | ).


    "7.FUNCIONES TO_LOWER Y TO_UPPER

    DATA mv_translate_invoice TYPE string VALUE '“Report the issuance of this invoice'.

    TRANSLATE mv_translate_invoice TO UPPER CASE.
    out->write( |Translate To Upper Case: { mv_translate_invoice } | ).

    TRANSLATE mv_translate_invoice TO LOWER CASE.
    out->write( |Translate To lower Case: { mv_translate_invoice } | ).

    "8.FUNCIONES INSERT Y REVERSE

    mv_count = strlen( mv_translate_invoice  ).
    mv_translate_invoice = insert( val = mv_translate_invoice sub = ' to client' off = mv_count ).
    out->write( |Funcion insert al final de la variable mv_translate_invoice : { mv_translate_invoice } | ).

    mv_translate_invoice = reverse( mv_translate_invoice ).
    out->write( |Reverse variable mv_translate_invoice: { mv_translate_invoice } | ).

    "1.OVERLAY

    DATA: lv_sale        TYPE string VALUE 'Purchase Completed',
          lv_sale_status TYPE string VALUE 'Invoice'.


    OVERLAY lv_sale WITH lv_sale_status ONLY 'Purchase'.

    out->write( |Superposicion de la variable "lv_sale" con "lv_sale_status": { lv_sale } | ).


    "2.FUNCION SUBSTRING

    DATA lv_result TYPE string VALUE 'SAP-ABAP-32-PE'.

    lv_result = substring( val = lv_result off = 9 len = 5 ).
    out->write( |Devolver el valor del "SubString" desde la pos. 9 a 14: { lv_result } | ).

    lv_result = 'SAP-ABAP-32-PE'.

    DATA(lv_result2) = substring_after( val = lv_result sub = 'ABAP' ).
    out->write( |Devolver el valor despues del substring "ABAP": { lv_result2 } | ).

    lv_result2 = substring_before( val = lv_result sub = 'ABAP' ).
    out->write( |Devolver el valor antes del substring "ABAP": { lv_result2 } | ).

    "3.FIND

    DATA: lv_status TYPE string VALUE 'INVOICE GENERATED SUCCESSFULLY',
          lv_count  TYPE i.

    lv_count = find_any_of( val = lv_status sub = 'GEN' ).
    out->write( |1era posicion de cuales quiera subString "GEN" en "lv_status": { lv_count + 1 } | ).

    lv_count = count( val = lv_status sub = 'A' ).
    out->write( |Cantidad de subString "A" en la varibale "lv_status": { lv_count } | ).

    "4.REPLACE

    DATA lv_request TYPE string VALUE 'SAP-ABAP-32-PE'.
    lv_request = replace( val = lv_request sub = '-' with = '/' occ = 0 ).

    out->write( |Reemplazar los "-" por "/" en la variable "lv_request": { lv_request } | ).

    "5.PCRE REGEX

    DATA: lv_regex TYPE string VALUE '^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$',
          lv_email TYPE string VALUE 'PEDRITOPEREZ@GMAIL.COM'.

    FIND REGEX lv_regex IN lv_email IGNORING CASE.

    IF sy-subrc EQ 0.
      out->write( 'El correo tiene un formato CORRECTO' ).
    ELSE.
      out->write( 'El correo tiene un formato INCORRECTO' ).
    ENDIF.

    "6.EXPRESIONES REGULARES

    DATA: lv_idcustome TYPE string VALUE '0000012345'.

    lv_regex = '0*'.
    lv_idcustome = replace( val = lv_idcustome regex = lv_regex with = `` occ = 0 ).
    out->write( |Variable LV_IDCUSTOME sin Ceros { lv_idcustome } | ).

    "7. REPETICION DE STRINGS

    lv_idcustome = repeat( val = lv_idcustome occ = 3 ).
    out->write( |Variable LV_IDCUSTOME triplicada { lv_idcustome } | ).

    "8.FUNCION ESCAPE

    DATA lv_format TYPE string VALUE 'Send payment data via Internet'.

    DATA(lv_transf) = escape( val = lv_format format = cl_abap_format=>e_url_full ).
    out->write( |Variable lv_format en formato URL: { lv_transf } | ).

    lv_transf = escape( val = lv_format format = cl_abap_format=>e_json_string ).
    out->write( |Variable lv_format en formato JSON: { lv_transf } | ).

    lv_transf = escape( val = lv_format format = cl_abap_format=>e_string_tpl ).
    out->write( |Variable lv_format en formato String templates: { lv_transf } | ).

  ENDMETHOD.
ENDCLASS.
