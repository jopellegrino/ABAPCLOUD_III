CLASS zcl_10_decl_en_linea_y_forzado DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_10_DECL_EN_LINEA_Y_FORZADO IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "DECLARACIONES EN LINEA

    DATA(lv_mult) = 8 * 16.         "EL LENGUAJE ASIGNO IMPICITAMENTE UN TIPO I LENTGH 4
    out->write( |{ lv_mult }| ).


    DATA(lv_div) = 8 / 16.          "EL LENGUAJE LE ASIGNO TIPO I LENTGH 4 (ESTO HACE QUE SE PIERDA INFO)
    out->write( |{ lv_div }| ).

    DATA(lv_text) = 'ABAP I - 2025'. "EL LENGUAJE ASIGNO TIPO C
    out->write( |{ lv_text }| ).

    DATA(lv_dec) = '10.254'.        "EL LENGUAJE LE ASIGNO UN TIPO C, EN VEZ DE DECIMAL
    out->write( |{ lv_dec }| ).

    out->write( | | ).

    "CONVERSIONES DE TIPO FORZADO

    DATA(lv_date_inv) = '20250101'.
    out->write( |Tipo Original (c):{ lv_date_inv }| ). "ABAP LE ASIGNO TIPO C, EN VEZ DE FECHA

    DATA(lv_date_inv2) = CONV d( lv_date_inv ). "FORZANDO EL TIPO A DATE (d), VOLCANDO EN OTRA VARIABLE.
    out->write( |Tipo Forzado (d): lv_date_inv2 DATE = USER | ).


  ENDMETHOD.
ENDCLASS.
