CLASS zcl_lab_04_message_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_04_message_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "1. SIMBOLO DE TEXTO
    out->write( TEXT-001 ).

    "2. FUNCIONES DE DESCRIPCION
    DATA: lv_order_status TYPE string VALUE 'Purchase Completed Successfully',
          lv_char_number  TYPE i.

    out->write( |El Valor de la variable lv_order_status: { lv_order_status } | ).

    lv_char_number = strlen( 'LV_ORDER_STATUS' ).
    out->write( |La Longitud de caracteres usando STRLEN() de LV_ORDER_STATUS es: { lv_char_number } | ).

    lv_char_number = numofchar( 'LV_ORDER_STATUS' ).
    out->write( |La Longitud de caracteres usando NUMOFCHAR() de LV_ORDER_STATUS es: { lv_char_number } | ).

    FIND ALL OCCURRENCES OF 'A' IN lv_order_status MATCH COUNT lv_char_number IGNORING CASE.
    out->write( |La cantidad de los caracteres "A" dentro de LV_ORDER_STATUS es: { lv_char_number } | ).

    lv_char_number = find( val = lv_order_status sub = 'Exit' ).

    IF contains( val = lv_order_status sub = 'Exit'  ).
      out->write( |La Posicion del SubString "Exit" en la variable LV_ORDER_STATUS es: { lv_char_number }| ).
    ELSE.
      out->write( |La variable LV_ORDER_STATUS no contiene el patron "Exit"| ).
    ENDIF.

    "3. FUNCIONES DE PROCESAMIENTO

    lv_order_status = to_upper( lv_order_status ).
    out->write( |Fomato de variable LV_ORDER_STATUS en Muyusculas: { lv_order_status } | ).

    lv_order_status = to_lower( lv_order_status ).
    out->write( |Fomato de variable LV_ORDER_STATUS en Minusculas: { lv_order_status } | ).

    lv_order_status = to_mixed( val = lv_order_status sep = ` ` case = 'X' ).
    out->write( |Fomato de variable LV_ORDER_STATUS en Mixed: { lv_order_status } | ).

    lv_order_status = 'Purchase Completed Successfully'.

    out->write( lv_order_status ).
    lv_order_status = shift_left( val = lv_order_status circular = 9 ).
    out->write( |Desplazamiento en 9 caracteres de  la variable LV_ORDER_STATUS:{ lv_order_status } | ).

    DATA(subString) = substring_from( val = lv_order_status sub = lv_order_status  len = 9 ).
    out->write( |Extracion de "Completed" de  la variable LV_ORDER_STATUS: { subString } | ).

    out->write( |Revertir de la variable LV_ORDER_STATUS: { reverse( lv_order_status ) } | ).

    "4.FUNCIONES DE CONTENIDO

    DATA: lv_pattern TYPE string VALUE '\d{3}-\d{3}-\d{4}',
          Lv_phone   TYPE string VALUE '646-464-6464'.

    IF contains( val = Lv_phone pcre = lv_pattern ).
      out->write( |El formate del numero de telefono ingresado es CORRECTO| ).
    ELSE.
      out->write( |El formate del numero de telefono ingresado es INCORRECTO| ).
    ENDIF.

    "5. FUNCIONES CON EXPRESIONES REGULARES

    DATA lv_email TYPE string VALUE 'PEPITOPEREZGMAIL.COM'.
    lv_pattern = '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'.

    IF contains( val = lv_email pcre = lv_pattern ).
      out->write( |El correo ingresado es VALIDO| ).
    ELSE.
      out->write( |El correo ingresado es INVALIDO| ).
    ENDIF.


  ENDMETHOD.
ENDCLASS.
