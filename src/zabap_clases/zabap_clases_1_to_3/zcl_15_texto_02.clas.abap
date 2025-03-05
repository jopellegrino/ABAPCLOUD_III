CLASS zcl_15_texto_02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_15_TEXTO_02 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_string    TYPE string,
          lv_char_1(4) TYPE c,               "LENGTH DEFINIDA EN 4
          lv_char_2    TYPE c,               "AL NO DEFINIR EL LEN EL TAMAÑO ES 1
          lv_char_3.                         "AL NO DARLE TIPO ENTONCES ES TIPO C

    DATA: lv_n(20) TYPE n  VALUE '1234567'.  "CARACTERES DE NUMEROS Y LETRAS, PERO SI LLEVA LETRAS NO USAR PARA CALCULOS

    DATA(lv_string_f) = 'ABC'.



    """"""""""CONCATENACION""""""""""

    DATA: lv_string_a TYPE string VALUE 'Welcome to Logali Group',
          lv_string_b TYPE string.

    lv_string_b = 'ABAP' && ` ` && 'Student'.                                      "CONC. && y EL ` ` DA ESPACIO
    out->write( |Conc. usando "&&": { lv_string_b }| ).

    CONCATENATE lv_string_a lv_string_b INTO DATA(lv_conc) SEPARATED BY space.     "CONC. CON OPERADOR CONCATENATE
    out->write( |Conc. (1) usando Operador "Concatenate": { lv_conc }| ).

    CONCATENATE 'x' 'y' 'z' INTO DATA(lv_conc2) RESPECTING BLANKS.                 "NO RESPETA LOS ESPACIOS, SI AGREGO RESP. BLANKS
    out->write( |Conc. (2) usando Operador "Concatenate": { lv_conc2 }| ).

    DATA(lv_conc3) = |Conc. usando barra vertical: { lv_conc } / { lv_string_b }|.
    out->write( lv_conc3 ).



    SELECT FROM /dmo/flight             "SE TRAE LA INFO DE ESTA TAB. DE BBDD
        FIELDS carrier_id
        INTO TABLE @DATA(lv_itab).      "Y SE BOLCA TODO EN ESTA TAB INTERNA

    DATA(lv_string_itab) = concat_lines_of( table = lv_itab sep = ` ` ).   "SE LE PASA LA TABLA LLENA DE INFO
    out->write( |Conc. de datos de tabla: { lv_string_itab }| ).           "CONC. LINEAS O REGISTROS DE UNA TAB INTERNA


    out->write( |  | ).

    """"""""""CONDENSE"""""""""""

    lv_string_a = 'Welcome      to Logali Group'.
    out->write( |Texto Original:                      { lv_string_a } | ).

    CONDENSE lv_string_a.                                                     "ELIMINA LOS ESPACIOS INNECESARIOS
    out->write( |Texto con operador condense:         { lv_string_a } | ).

    CONDENSE lv_string_a NO-GAPS.
    out->write( |Texto con operador condense no-gaps: { lv_string_a } | ).    "ELIMINA TODOS LOS ESPACIOS

    lv_string_a = '    Welcome      to Logali Group    '.
    lv_string_a = condense( val = lv_string_a from = ` ` ).                   "PARAMETRO FROM ELIMINA ESPACIOS INN. AL INCIO Y FINAL
    out->write( |Texto con funcion condense y FROM : { lv_string_a } | ).

    lv_string_a = '    Welcome      to Logali Group   '.
    lv_string_a = condense( val = lv_string_a to = `` ).                      "PARAMETRO TO ELIMINA TODOS LOS ESPACIOS U OTRO CARACTER (COMO EL NO-GAPS)
    out->write( |Texto con funcion condense y TO : { lv_string_a } | ).

    lv_string_a = condense( val = '¡¡¡¡ABAP¡¡¡¡COURSE¡¡¡' del = '¡' ).        "PARAMETRO DEL, ELIMINA EL CARACTER DESEADO INICIO AL FINAL
    out->write( |Texto con funcion condense y DEL=¡ : { lv_string_a } | ).


    out->write( |  | ).

    """"""""""SPLIT""""""""""
    DATA(lv_string_1) = 'Logali-Group-SAP-Academy'.
    SPLIT lv_string_1 AT '-' INTO DATA(lv_word1)            "CORTA EN PARTES USANDO SIMBOLO UN SEPARADOR
                                  DATA(lv_word2)
                                  DATA(lv_word3)
                                  DATA(lv_word4).

    out->write( |Usando Split Palabra 1: { lv_word1 }  Palabra 2: { lv_word2 }  Palabra 3: { lv_word3 }  Palabra 4: { lv_word4 } | ).


    """"""""""SEGMENT""""""""""

    lv_word3 = segment( val = lv_string_1 index = 3 sep = '-' ).  "INDEX ES POSICION DE LA SEPARACION QUE QUEREMOS, Y SEP ES EL PATRON DE SEPARACION
    out->write( |Usando Segment Palabra 3: { lv_word3 } | ).




  ENDMETHOD.
ENDCLASS.
