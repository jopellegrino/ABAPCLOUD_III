CLASS zcl_25_itab2_enum_y_rangos DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_25_itab2_enum_y_rangos IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""""""ITABLAS DE RANGOS(DEPOSITO INTERNO DE RANGOS, SE PUEDE USAR EN EL WHERE COMO FILTRO) "4,14

    TYPES lty_price TYPE RANGE OF /dmo/flight-price.              "ITAB TIPO RANGO

    DATA(lt_price_range) = VALUE lty_price( ( sign   = 'I'          "INCLUIR LOS VALORES, ESTABLECE LA FORMA QUE TENDRA LA TABLA

                                              option = 'BT'         "QUE ESTEN BETWEEN
                                              low   = '600'         "RANGO DEL ENTRE LOW Y HIGHT
                                              high  = '1000' ) ).   "TODAS ESTAS SON LAS CARACTERISTICAS DE LA TABLA HAY MAS CARACTERISTICAS, VID 4.14 ITAB2

    SELECT *
    FROM /dmo/flight
    WHERE price IN @lt_price_range  "USAR ESTA TABLA HACE QUE SOLO SE TRAIGA ESE RANGO, ES COMO UN FILTRO HECHO TABLA
    INTO TABLE @DATA(ltr_price).    "Y SE USA OTRA TABLA PARA VOLCAR TODO


    SORT ltr_price BY price.        "ORDENA DE FORMA ASCENDETE POR EL CAMPO PRICE A LA TABLA

    out->write( data = lt_price_range name = 'LTR_PRICE_RANGE (CONDICION)' ).
    out->write( data = ltr_price name = 'LTR_PRICE' ).
    out->write( | | ).


*   """""""""ENUMERACIONES (TIPOS Y CONSTANTES)

    TYPES: BEGIN OF ENUM gty_colors,
             c_white,                   "CONSTANTES DE ENUMERACION
             c_black,
             c_purple,
             c_red,
             c_blue,
           END OF ENUM gty_colors.

    DATA lv_color TYPE gty_colors VALUE c_purplE.  "SOLO PUEDE TENER LOS VALORES DE SU TIPO, NADA MAS
    out->write( lv_color ).


    lv_color = c_black.
    out->write( lv_color ).
    out->write( | | ).

*    "ENUMERADO COMO STRUCTURA

    TYPES: BEGIN OF ENUM gty_colors_02 STRUCTURE ls_type,   "AHORA SE DEBE ACCEDER A LA STRUCT, Y LUEGO AL CAMPO USANDO -
             c_white,                                       "CONSTANTES DE ENUMERACION, TAMBIEN SE LES ASIGNA UN NUMERO, 0,1,2,3,4 EN ESTE CASO
             c_black,
             c_purple,
             c_red,
             c_blue,
           END OF ENUM gty_colors_02 STRUCTURE ls_type.

    DATA lv_color_02 TYPE gty_colors_02.

    out->write( lv_color_02 ).                              "CUANDO NO ASIGNAS VALOR INICIAL, IMPRIME LA PRIMEA CONSTANTE DE ENUM

    lv_color_02 = ls_type-c_red.
    out->write( lv_color_02 ).

    CASE lv_color_02.
      WHEN ls_type-c_white.
        out->write( 'The Color is White' ).
      WHEN ls_type-c_black.
        out->write( 'The Color is Black' ).
      WHEN ls_type-c_purple.
        out->write( 'The Color is Purple' ).
      WHEN ls_type-c_red.
        out->write( 'The Color is Red' ).
      WHEN ls_type-c_blue.
        out->write( 'The Color is Blue' ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
