CLASS zcl_3_exprns_agrgcn_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_3_exprns_agrgcn_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""MIN - MAX (EXPRESIONES SQL)(VALORES MINIMOS Y MAXIMOS DE UNA COLUMNA VALORES NUMERICOS)

    """""MIN
    out->write( |"""""MIN - MAX"""""| ).

    SELECT FROM /dmo/i_flight
    FIELDS MIN( MaximumSeats )
    INTO @DATA(lv_min_seats).                 "SE OBTIENE SOLO UN REGISTROS, EL MINIMO, AUNQUE PUEDE HABER DUPLICADOS

    IF sy-subrc = 0.
      out->write( |Min Seats: { lv_min_seats }| ).
    ENDIF.


    """""MAX Y MIN JUNTOS EN DOS VARIABLES

    SELECT FROM /dmo/i_flight
    FIELDS MIN( MaximumSeats ) AS MinSeats,                      "EL REGISTROS(VUELO) CON MENOS HACIENTOS EN HACIENTOS MAXIMOS PERMITIDOS
           MAX( MaximumSeats ) AS MaxSeats                       "EL REGISTRO(VUELO) CON MAS HACIENTOS EN HACIENTOS MAXIMOS PERMITIDOS
    INTO ( @lv_min_seats, @DATA(lv_MAX_seats)  ).                "SE OBTIENE DOS REGISTROS, CADA UNO EN SU VARIABLE CORRESPONDIENTE POR EL ORDEN COLOCADO

    IF sy-subrc = 0.
      out->write( |Min Seats: { lv_min_seats }; Max Seats: { lv_MAX_seats }| ).
    ENDIF.


    """""MAX Y MIN JUNTOS EN UNA STRUCTURA CREADA EN LINEA

    SELECT FROM /dmo/i_flight
    FIELDS MIN( MaximumSeats ) AS MinSeats,
           MAX( MaximumSeats ) AS MaxSeats
    INTO @DATA(ls_min_max_seats).                 "SE OBTIENE DOS REGISTROS, Y SE COLOCA EN LA STRUCTURA

    IF sy-subrc = 0.
      out->write( ls_min_max_seats ).
    ENDIF.

    out->write( | | ).

*    """""AVG - SUM (PROMEDIO Y SUMATORIO DE DATOS EN LA BBDD)

    out->write( |"""""AVG - SUM"""""| ).

    SELECT FROM /dmo/i_flight
    FIELDS AVG( MaximumSeats ) AS AvgSeats,
           SUM( MaximumSeats ) AS SumSeats
           WHERE AirlineID = 'AA'
    INTO ( @DATA(lv_avg_seats), @DATA(lv_sum_seats) ).      "SE TRAE EL PROMEDIO Y EL SUMATORIO DE LOS CAMPOS SELECCIONADOS Y LO COLOCA EN ESAS VARIABLES, EN EL ORDEN

    IF sy-subrc = 0.
      out->write( | Avg Seats: { lv_avg_seats }; Sum Seats: { lv_sum_seats } | ).

    ENDIF.
    out->write( | | ).


*    """""DISTINCT (SE PUEDE COLOCAR EN LAS CLAUSULAS DE AGREGACION)(SOLO TOMA EN CUENTA UNA VEZ LOS CAMPOS QUE ESTAN REPETIDOS)

    out->write( |"""""DISTINCT"""""| ).

    SELECT FROM /dmo/i_flight
    FIELDS AVG( DISTINCT MaximumSeats ) AS AvgSeats,  "SOLO TOMA EN CUENTA UNA VEZ CADA CAMPO REPETIDO
           SUM( DISTINCT MaximumSeats ) AS SumSeats
           WHERE AirlineID = 'AA'
    INTO ( @lv_avg_seats, @lv_sum_seats ).

    IF sy-subrc = 0.
      out->write( | Avg Seats: { lv_avg_seats }; Sum Seats: { lv_sum_seats } | ).
    ENDIF.

    out->write( | | ).


*   """""COUNT (DEVUELVE EL NUMERO DE REGISTROS QUE CUMPLEN LA CONDICION DEL FILTRO APLICADO(SI HAY FILTRO))

    out->write( |"""""COUNT"""""| ).

    SELECT FROM /dmo/i_flight
    FIELDS COUNT( * ) AS CountAll,                              "CUENTA TODOS LOS REGISTROS DE LA TABLA YA QUE NO COLOCAMOS UNA COLUMNA COMO DISTINC
           COUNT( DISTINCT MaximumSeats ) AS CountMaxSeats      "NO TRAE LOS VALORES DUPLICADOS, Y SOLO CUENTA UNA VEZ UN DUPLICADO
           WHERE AirlineID = 'AA'
           INTO ( @DATA(lv_count_all), @DATA(lv_distinct_seats) ).

    IF sy-subrc = 0.
      out->write( | Count All: { lv_count_all }; Count Distinct: { lv_distinct_seats } | ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
