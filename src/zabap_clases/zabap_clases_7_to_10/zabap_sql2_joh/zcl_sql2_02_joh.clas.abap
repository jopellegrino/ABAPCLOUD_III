CLASS zcl_sql2_02_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sql2_02_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""IN (COMPARACION POR RANGO DE VALORES)(DIFERENCIA A TABLA DE RANGOS, QUE TIENE SUS COMPARACIONES INTERNAMENTE)

    out->write( |"""""IN"""""| ).

    SELECT FROM zcarrier_joh
    FIELDS *
    WHERE carrier_id IN ( 'AA', 'AC', 'JL', 'WZ' )     "TRAE DE LA BBDD LOS VALORES CON ESTOS CARRIER_ID, PERMITE PASAR MULTIPLES VALORES PARA COMPARACION
    INTO TABLE @DATA(lt_airlines).

    IF sy-subrc = 0.
      out->write( lt_airlines ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*    """""IN CON TABLA DE RANGO DE VALORES (SIGN, OPTION, LOW y HIGH)

    out->write( |"""""IN (CON ITAB RANGO DE VALORES)"""""| ).

    DATA lr_price TYPE RANGE OF /dmo/price.        "ITAB DE RANGOS, TIPO PRICE, CAMPO QUE USARE EN LA QUERY

    lr_price = VALUE #( ( sign   = 'I'             "(I) INCLUIR O (E)EXCLUIR
                          option = 'BT'            "BT LLEVA LOW Y HIGH, Y OTROS OPERADORES BINARIOS DE COMPARACION
                          low    = 500
                          high   = 1500   ) ).

    APPEND VALUE #( sign   = 'I'
                    option = 'EQ'
                    low    = '4996.00'  ) TO lr_price.   "ESTA ITAB PERMITE AGREGAR MAS RANGOS CON APPEND, USA SOLO LOW, PORQUE ES EQ

    SELECT FROM zflight_joh
    FIELDS *
    WHERE price IN @lr_price        "COMPARA CON LO ENCONTRADO DENTRO DE LA ITAB DE RANGOS
    INTO TABLE @DATA(lt_flights).

    IF sy-subrc = 0.
      out->write( lt_flights ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*    """""NULL
    out->write( |"""""VALORES (NULL-VACIO-ESPACIO)"""""| ).

    CONSTANTS lc_no_value TYPE c VALUE ''.     "CTTE SIN VALOR, NO SIGNIFICA QUE SEA NULL

    SELECT FROM zflight_joh
       FIELDS *
       WHERE currency_code IS NULL                 "TRAE LOS VALORES NULOS, SI COLOCAS IS NOT NULL TRAE TODOS LOS NO NULOS
       OR currency_code = @lc_no_value             "CTTE SIN VALOR
       OR currency_code = @space                   "ESTO ES UNA VARIABLE QUE DA UN ESPACIO
       INTO TABLE @DATA(lt_flight2).

    IF sy-subrc = 0.
      out->write( lt_flight2 ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*    """""AND - OR - NOT

    out->write( |"""""AND - OR - NOT"""""| ).

    SELECT FROM /DMO/I_Connection
    FIELDS *
    WHERE (   AirlineID = 'AA'              "TODA ES CLAUSULA WHERE DEBE DAR TRUE O FALSE PARA INCORPORAR O NO LOS REGISTROS
           OR AirlineID = 'LH' )
                    AND
          (   DepartureAirport = 'SFO'      "ES POSIBLE USAR PARENTESIS COMO EN OPERACIONES ARIMETICAS, PARA MODIFICAR EL ORDEN
           OR DepartureAirport = 'JFK'   )
                    AND
           NOT ConnectionID = '0015'        "NOT INVIERTE EL VALOR DE UNA CONDICION, DE FALSA A VERDADERA Y VICEVERSA
    INTO TABLE @DATA(lt_flight3).

    IF sy-subrc = 0.
      out->write( lt_flight3 ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


  ENDMETHOD.
ENDCLASS.
