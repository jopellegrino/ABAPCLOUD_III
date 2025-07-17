CLASS zcl_11_joins_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_11_joins_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*  """""LEFT JOIN EXCLUDING INNER JOIN (NO HAY FUNCION, HAY QUE REALIZARLO CON SUBQUERYS)

    out->write( |""""LEFT JOIN EXCLUDING INNER JOIN"""""| ).

    SELECT FROM zdatasource_1 AS ds1
    FIELDS *
    WHERE ds1~id NOT IN ( SELECT FROM zdatasource_2 AS ds2
                                 FIELDS ds2~id
                                 WHERE ds2~id EQ ds1~id  )    "ESTO DICE TRAME TODOS LOS DATOS EN A, EXCLUYENDO LOS QUE TENGA EN COMUN CON B
     INTO TABLE @DATA(lt_result_excl_left).                             "FUNCIONARIA SIN COLOCAR EL WHERE EN LA SUBQUERY PERO SERIA MENOS EFICIENTE YA QUE REVISARIA TODA LA FUENTE B

    IF sy-subrc EQ 0.
      out->write( lt_result_excl_left ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.
    out->write( | | ).


*  """""RIGHT JOIN EXCLUDING INNER JOIN (NO HAY FUNCION, HAY QUE REALIZARLO CON SUBQUERYS)

    out->write( |""""RIGHT JOIN EXCLUDING INNER JOIN"""""| ).

    SELECT FROM zdatasource_2 AS ds2
    FIELDS *
    WHERE ds2~id NOT IN ( SELECT FROM zdatasource_1 AS ds1
                                 FIELDS ds1~id
                                 WHERE ds1~id EQ ds2~id  )
     INTO TABLE @DATA(lt_result_excl_right).

    IF sy-subrc EQ 0.
      out->write( lt_result_excl_right ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).


*   """""CROSS JOIN""""" UNA COMBINACION DE MULTIPLICIDAD ENTRE TODOS LOS CAMPOS DE AMBAS TABLAS DE BBDD SI A TIENE 5 Y B 5 CAMPOS ENTONCES EL RESULTADO ES 5X5=25 CAMPOS

    out->write( |"""""CROSS JOIN"""""| ).

    SELECT FROM zdatasource_1 AS ds_1
        CROSS JOIN zdatasource_2 AS ds_2 "ON ds_1~id eq ds_2~id             "EN ESTE CASO EL ON NO ESTA PERMITIDO
        FIELDS *
        "WHERE DS_2~ID EQ '02'              "ES POSIBLE FILTRAR
        INTO TABLE @DATA(lt_result_cross).

    IF sy-subrc EQ 0.
      out->write( lines( lt_result_cross ) ).    "CANTIDAD DE REGISTROS
      out->write( lt_result_cross ).             "IMPRESION DE REGISTROS
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).

*   """""CROSS JOIN TRIPLE"""""

    out->write( |"""""CROSS JOIN TRIPLE"""""| ).

    SELECT FROM zdatasource_1 AS ds_1
     CROSS JOIN zdatasource_2 AS ds_2
     CROSS JOIN zdatasource_3 AS ds_3
        FIELDS *
        INTO TABLE @DATA(lt_result_cross_tr).

    IF sy-subrc EQ 0.
      out->write( lines( lt_result_cross_tr ) ).    "CANTIDAD DE REGISTROS
      out->write( lt_result_cross_tr ).             "IMPRESION DE REGISTROS
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.




  ENDMETHOD.
ENDCLASS.
