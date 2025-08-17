CLASS zcl_sql_04_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SQL_04_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*   """""ACTUALIZAR COLUMNAS CON SET Y UPDATE (A EUR LOS CAMPOS CURRENCY CODE)

    CONSTANTS lc_currency TYPE c LENGTH 3 VALUE 'USD'.

    UPDATE zcarrier_joh
           SET currency_code = @lc_currency       "INDICAMOS LAS COLUMNAS QUE QUIERES ACTUALIZAR Y EL VALOR QUE SE LE QUIERE DAR
 "           , NAME = 'Avianca'                   "SE PUEDE AGREGAR MAS CULUMNAS CON COMA
               WHERE carrier_id = 'LH'            "REGISTROS QUE CUMPLEN LA CONDICIONES QUE SE QUIEREN MODIFICAR (MAYOR MENTE KEYS), NO SE PUEDE MODIFICAR KEYS
                  OR carrier_id = 'AF'.           "SI NO SE COLOCA EL WHERE MODIFICARA TODOS LOS REGISTROS (!!!CUIDADO!!!)

    IF sy-subrc = 0.
      out->write( |Las columnas fueron actualizadas correctamente| ).
    ELSE.
      out->write( |No se ha actualizado las culumnas correctamente| ).
    ENDIF.




*   """""ACTUALIZAR COLUMNAS CON EXPRESIONES (SE DESEA AUMENTAR EN 10 TODOS LOS SEATS)

    """""LLENADO DE LA BBDD DE PRUEBA

    DATA lt_flight TYPE STANDARD TABLE OF zflight_joh.   "SE DECLARA UNA ITABLA TIPO LA DE BBDD


    delete from zflight_joh.                             "LO BORRO SOLO PARA QUE PUEDA HACER EL CODIGO DE ABAJO CADA VEZ QUE EJECUTO

    SELECT FROM /dmo/i_flight                            "SE TOMAN LOS DATOS DE UNA CDS
    FIELDS AirlineID      AS airline_id,
            ConnectionID  AS connection_id,
            FlightDate    AS flight_date,
            price         AS price,
            CurrencyCode  AS currency_code,
            PlaneType     AS plane_type,
            MaximumSeats  AS maximum_seats,
            OccupiedSeats AS occupiedseats
    INTO CORRESPONDING FIELDS OF TABLE @lt_flight.      "SE VOLCAN EN LA ITAB DECLARADA

    IF sy-subrc = 0.                                    "SE VERIFICA EL VOLCADO
      INSERT zflight_joh FROM TABLE @lt_flight.         "SE INSERTAN LOS DATOS EN LA BBDD A PARTIR DE LA ITAB

      IF sy-subrc = 0.                                  "SE VERIFICA EL INSERT
        out->write( |Inserted rows { sy-dbcnt }| ).
      ENDIF.
    ENDIF.

    "ACTUALIZACION DIRECTA A LA BBDD CON EXPRESIONES SIN ITABS

    UPDATE zflight_joh
          SET maximum_seats = maximum_seats + 10,           "SOLO SE PUEDE COLOCAR LA MISMA COLUMNA QUE ES EL MISMO + 10, NO OTRA SOLO SUMAS O RESTAS
              occupiedseats = occupiedseats + 5             "EXPRESIONES MAS COMPLEJAS DEBEN HACERSE CON ABAP, CON BUCLES ETC
          WHERE airline_id = 'LH'.

    IF sy-subrc = 0.
      out->write( |Las columnas fueron actualizadas correctamente, cantidad { sy-dbcnt }| ).
    ELSE.
      out->write( |No se ha actualizado las culumnas correctamente| ).
    ENDIF.









  ENDMETHOD.
ENDCLASS.
