CLASS zcl_funciones_sql_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_funciones_sql_1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""FUNCIONES NUMERICAS"""""

    out->write( 'FUNCIONES NUMERICAS' ).

    DATA(gv_offset) = 18.
    DATA gv_decimal TYPE p LENGTH 13 DECIMALS 4 VALUE '27.0671'.

    DELETE FROM zdmo_exprssn_joh.           "NO DE FORMAR PARTE DE NINGUN PROYECTO EMPRESARIAL

    MODIFY zdmo_exprssn_joh FROM @( VALUE #( id   = 'L'
                                             num1 = 14
                                             num2 = 8      ) ).
    SELECT SINGLE FROM zdmo_exprssn_joh
    FIELDS id,
           num1,
           num2,
           CAST( num1 AS FLTP ) / CAST( num2 AS FLTP ) AS Ratio,       "HACER DIVISIONES SE PUEDE CONVERTIR EL VALOR NUMERICO EN PUNTO FLOTANTE, DA NOTACION CIENTIFICA
           division( num1, num2, 2 )                   AS Division,    "CADA COLUMNA DE LA TABLA NUM1/NUM2 CON 2 DECIMALES
           div( num1, num2 )                           AS Div,         "SOLO LA PARTE ENTERA DE LA DIVISION
           mod( num1, num2 )                           AS Mod,         "RESTO DE LA DIVISION
           num1 + num2 + @gv_offset                    AS Sum,         "SUMA DIRECTA USANDO UNA VAR, CON CAMPOS
           abs( num1 - num2 )                          AS Abs,         "VALOR ABSOLUTO
           @gv_decimal                                 AS Decimal,     "UN VALOR DECIMAL SACADO DE UNA VAR, COLOCADO EN UNA ITAB
           ceil( @gv_decimal )                         AS Ceil,        "REDONDEO HACIA ARRIBA, ENTERO
           floor( @gv_decimal )                        AS Floor,       "REDONDEO HACIA ABAJO ENTERO
           round( @gv_decimal, 2 )                     AS Round        "REDONDEO, POR 2 DECIMALES
   WHERE id EQ 'L'
   INTO @DATA(ls_result).

    IF sy-subrc EQ 0.
      out->write( ls_result ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*    """""FUNCIONES DE CONCATENACION

    out->write( 'FUNCIONES DE CONCATENACION' ).

    CONSTANTS lc_char TYPE c LENGTH 6 VALUE 'LOGALI'.

    MODIFY zdmo_exprssn_joh FROM @( VALUE #( id   = 'L'
                                             char1 = 'AABbCDDe'
                                             char2 = '123456'      ) ).

    SELECT SINGLE FROM zdmo_exprssn_joh
    FIELDS  id,
            char1,
            char2,
            concat( char1, char2 ) AS Concat,                        "CONCATENA DOS CAMPOS, COLUMNAS O VARIABLES DE HOST (CONSTANTES ECT)
            concat_with_space( char1, @lc_char, 2 ) AS ConcatSpace,  "CONCATENA PERO CON ESPACIOS, EL NUMERO INDICA EL NUMERO DE ESPACIOS
            concat( char1, concat( char1, char2 ) ) AS ConcatTriple, "PARA CONCATENAR MAS DE DOS CARACTERES, USANDO VARIAS VECES CONCANT
            char1 && char2 && 'ABAPCLOUD' && @lc_char AS Ampersand   "CONCATENACION CON && (AMPERSAND)
    WHERE id EQ 'L'
    INTO @DATA(ls_result_concat).

    IF sy-subrc EQ 0.
      out->write( ls_result_concat ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*    """""FUNCIONES DE CADENA DE CARACTERES"""""

    out->write( |FUNCIONES DE CADENA DE CARACTERES| ).

    SELECT SINGLE FROM zdmo_exprssn_joh
    FIELDS id,
           char1,
           char2,
           left( char1, 2 ) AS Left,   "EXTRAER CHARS DESDE LA IZQ, AGREGANDO EL NUMERO EXTRAIDO
           right( char1, 3 ) AS Right,  "DEVUELVE LOS ULTIMOS 3 CHAR DESDE LA PARTE DERECHA
           lpad( char2, 18, '0' ) AS Lpad,      "LEFTPAD RELLENA POR UN NUMERO DE CHAR INDICADO (0) POR LA IZQ, HASTA COMPLETAR LA CANTIDAD 18
           rpad( char2, 18, '0' ) AS Rpad,      "IGUAL QUE ARRIBA PERO DESDE LA DER
           ltrim( char1, 'A' )    AS Ltrim,     "EXTRAE 'A' EMPEZANDO DESDE LA IZQ
           rtrim( char1, 'e' )    AS Rtrim,
           instr( char1, 'bC' )   AS Instr,               "DEVUELVE EN QUE POSIC ESTA ESA CADENA EN MI CHAR
           substring( char1, 3, 2 ) AS Substring,         "EXTRA UN STRING SEGUN SU POSICION, DESDE LA POS 3 TRAE 2 CHAR
           substring( char1, instr( char1, 'bC' ), 2 ) AS Substring2,    "USANDO EL INSTR SE CONSIGUE LA POS DE UNA CADENA Y LUEGO SE COLOCA EN ESTA FUNCION QUE DA LA POS PARA EXTRAERLO
           LENGTH( CHAR1 ) AS Length,                      "LONGITUD TOTAL DE LA CADENA
           REPLACE( CHAR1, 'DD', '__' ) AS Replace,         "REEMPLAZA DD POR __
           lower( char1 ) as Lower,                         "VUELVE TODO MINUS
           upper( char1 ) as Upper                          "VUELVE TODO MAYUS
     where id EQ 'L'
    INTO @DATA(ls_result_char).

    IF sy-subrc EQ 0.
      out->write( ls_result_char ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).



  ENDMETHOD.
ENDCLASS.
