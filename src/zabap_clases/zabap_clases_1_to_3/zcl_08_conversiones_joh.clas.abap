CLASS zcl_08_conversiones_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_08_conversiones_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_string TYPE string VALUE '12345',
          lv_int    TYPE i.


    DATA: lv_date    TYPE d,
          lv_decimal TYPE p LENGTH 3 DECIMALS 2,
          lv_num     TYPE n LENGTH 6.

    lv_int = lv_string.        "COMPATIBLE ALMACENAR STRING EN I (SOLO SI SON NUMEROS)
    out->write( | L29-El String: { lv_string } | ).
    out->write( | L30-String en I: { lv_int } | ).


    lv_string = '20250101'.    "COMPATIBLE ALMACENAR STRING A DATE
    lv_date = lv_string.
    out->write( | L35-String en Date: { lv_date DATE = USER } | ). "USAR DATE = USER FORMATEA A VAR DATE PARA QUE SE VEA IGUAL QUE EL USER LO TIENE CONFIG.

    out->write( |  | ).

    lv_date = cl_abap_context_info=>get_system_date(  ). "CLASE GLOBAL CON EL METODO PARA OBTENER LA FECHA DEL SERVER ACTUAL
    out->write( | L40-Fecha del server en d:{ lv_date }| ). "IMPRIME EN FORMATO FECHA

    lv_int = lv_date.
    out->write( | L43-Dias desde 01/01/001 en i:{ lv_int }| ). "IMPRIME EN FORMATO I (DA EL CONTEO DE DIA DESDE EL 01,01,0001 HASTA LA FECHA ACTUAL)

    out->write( |  | ).

    lv_string = 'A1B2C3'.
    lv_num = lv_string.
    out->write( | L49-El String:{ lv_string } | ).
    out->write( | L50-El String en n:{ lv_num } | ). "ELIMINA LAS LETRAS, COLOCA CEROS, Y JUSTIFICA LOS NUMEROS HACIA LA DERECHA

  ENDMETHOD.
ENDCLASS.
