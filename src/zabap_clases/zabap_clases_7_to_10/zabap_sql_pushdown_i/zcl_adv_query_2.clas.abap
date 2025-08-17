CLASS zcl_adv_query_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ADV_QUERY_2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """"""LLENAR LA TABLA CON DATOS"""""

    TRY.

        DATA(lo_random) = cl_abap_random_INT=>create(                "LO QUE RECIBE ESTE METODO SE METE EN LA VAR
      EXPORTING
        seed = CONV i( cl_abap_context_info=>get_system_time(  ) )   "CREA # ALEATORIOS CON LA HORA COMO SEMILLA
        min = 1
        max = 100 ).                                                 "RANGO DE NUMEROS CREADOS

      CATCH cx_abap_random INTO DATA(lx_random).
        out->write( lx_random->get_text(  ) ).
        RETURN.
    ENDTRY.

    DELETE FROM zdmo_exprssn_joh.

    MODIFY zdmo_exprssn_joh FROM TABLE @( VALUE #( FOR i = 0 UNTIL i > 9 ( id = i                                   "ESTE FOR LLENA LA TABLA DE BBDD, LOS CAMPOS NUM1, NUM2 Y ID
                                                                           num1 = lo_random->get_next( )
                                                                           num2 = lo_random->get_next( ) ) ) ).


*  """""CASE (PERMITE INDICAR LOGICA EN BASE A LA MANERA DE SELECT LOS DATOS) Y ANIDAR LOS CASES

    out->write( |"""""CASE"""""| ).

    SELECT FROM zdmo_exprssn_joh
    FIELDS num1,
           num2,
          CASE                                                                     "SI SE CUMPLE LA CONDICION, SE SELECCIONA EL DATO, O FUNCION EN EL THEN, PUEDE SER UN LITERAL, VAR O CAMPO DE LA BBDD
              WHEN num1 < 50 AND num2 < 50 THEN 'AMBOS VALORES SON MENORES A 50'   "TODOS TIPOS PROYECTADOS O IMPRESOS DESPUES DEL THEN DEBEN DE SER DEL MISMO TIPO, YA QUE VAN A ESTAR EN LA MISMA COLUMNA EN LA ITAB
              WHEN num1 > 50 AND num2 > 50 THEN 'AMBOS VALORES SON MAYORES A 50'   "TAMBIEN SE PUEDEN HACER CAST PARA OBLIGAR QUE SEAN EL MISMO TIPO
              WHEN num1 = 50 AND num2 = 50 THEN 'AMBOS SON IGUALES A 50'
              ELSE 'Other Case 1'
              END AS ColumnCase1,                       "TODO EL BLOQUE CASE ES UNA COLUMNA CON SU NOMBRE EN LA ITAB

          CASE num1                                     "TAMBIEN PUEDE USAR PREGUNTANDO POR UN VALOR EN LA BBDD
            WHEN 10 THEN 'EL VALOR DE NUM1 ES 10'       "EN ESTE LA COND. NO ESTA EN CADA WHEN
            WHEN 20 THEN 'EL VALOR DE NUM1 ES 20'       "MUY UTIL PARA ESTADOS DE PEDIDOS
            ELSE 'VALOR DIFERENTE DE 10 Y 20'
          END AS ColumnCas2,

          CASE                                          "CASE ANINADO
             WHEN num1 < 50 AND num2 < 50 THEN CASE num1
                                                   WHEN 10 THEN 'The Value is 10'
                                                   WHEN 20 THEN 'The Value is 20'
                                                   ELSE 'Differemt then 10 or 20'
                                                   END       "END DEL SEGUNDO CASE SIN ALIAS
             WHEN num1 > 50 AND num2 > 50 THEN 'Both higher then 50'
           ELSE 'Other Case'
           END AS ColumnCase3

    ORDER BY ColumnCase1
    INTO TABLE @DATA(lt_result).


    IF sy-subrc EQ 0.
      out->write( lt_result ).
    ELSE.
      out->write( 'NO DATA'  ).
    ENDIF.

    out->write( | | ).


*    """""TABLAS GLOBALES TEMPORALES (SE USA PARA LLENARLA CON UNA ITAB, Y LUEGO HACER JOIN, ETC CON OTRA TAB EN LA BBDD PARA HACER PUSHDOWN

    out->write( |"""""TABLAS GLOBALES TEMPORALES"""""| ).

    DATA lt_employee TYPE STANDARD TABLE OF zemploy_joh. "SITUACION CUANDO QUIERES COMPRAR UNA ITAB CON UNA TABLA DE BBDD

    lt_employee = VALUE #( ( employ_id  = '00001'
                             first_name = 'John'
                             last_name  = 'Smith'  ) ).

    INSERT zemploy_joh FROM TABLE @lt_employee.         "PASANDO LA ITAB A LA TABLA GLOBAL TEMPORAL

    SELECT FROM zemploy_joh                             "UNA VEZ LLENADA LA TAB TEMPORAL SE PUEDE HACER COMPARACIONES CON OTRA TAB DE BBDD
    "INNER JOIN
    FIELDS *
    INTO TABLE @DATA(lt_results).

    IF sy-subrc EQ 0.
      out->write( lt_results ).
    ELSE.
      out->write( 'NO DATA'  ).
    ENDIF.

    out->write( | | ).


*    """""SUBCONSULTA WITH (TABLA TEMPORAL NO GLOBAL)

    out->write( |"""""TABLAS TEMPORALES (NO GLOBALES, ES PUSHDOWN, NO ES ITAB)"""""| ).

    WITH +tmp_table AS (                    "ALMANCENA TEMPORALMENTE LOS DATOS DE LA QUERY SIGUE SIENDO PUSHDOWN, QUE NO SE HAN TRAIDO A LA APP SIGUEN EN LA BBDD
                   SELECT FROM /DMO/I_Connection
                   FIELDS AirlineID,
                          ConnectionID,
                          DepartureAirport,
                          DestinationAirport
                    WHERE AirlineID EQ 'LH'     )  "HASTA AQUI SE SELECCIONARON LOS DATOS A USAR EN LA BBDD

                    SELECT FROM /DMO/I_Airport AS Airport       "LUEGO SE HACE UN INNER JOIN CON TODOS LOS DATOS EN LA BBDD

                    INNER JOIN +tmp_table AS TmpDataDeparture
                            ON airport~AirportID EQ TmpDataDeparture~DepartureAirport   "EL AIRPORTID (/DMO/I_Connection) ES IGUAL A AEROPUERTO DE SALIDA DE /DMO/I_Airport

                    INNER JOIN +tmp_table AS TmpDataDestination
                            ON airport~AirportID EQ TmpDataDestination~DestinationAirport

                    FIELDS *
                    ORDER BY TmpDataDeparture~DepartureAirport ASCENDING
                    INTO TABLE @DATA(lt_result3).                       "CUANDO ESTA INSTRUCCION TERMINA YA LA TABLA TEMPORAL NO EXISTE


    IF sy-subrc EQ 0.
      out->write( lt_result3 ).
    ELSE.
      out->write( 'NO DATA'  ).
    ENDIF.

    out->write( | | ).



*   """""INSERCION, MODIFICACION - SUBCONSULTA (INSERTA DIRECTAMENTE DESDE UNA TAB DE BBDD A OTRA TABLA EN LA BBDD, EVITANDO TRAERLOS A UNA ITAB)

    out->write( |"""""INSERT, MODIFY EN SUBCONSULTA"""""| ).

    modify zflights_joh FROM ( SELECT FROM /DMO/I_Flight AS flight
                                       INNER JOIN /DMO/I_Connection AS connection               "INSERTA SOLO LOS DATOS QUE POSEEN EL MISMO AirlineID Y CONNECTIONID, ENTRE /DMO/I_Flight Y /DMO/I_Connection
                                               ON flight~AirlineID    EQ connection~AirlineID
                                              AND flight~connectionid EQ connection~connectionid
                                              FIELDS flight~AirlineID AS airlineid,
                                                     flight~ConnectionID AS connectionid,
                                                     flight~FlightDate AS flightdate,
                                                     connection~DepartureAirport AS deparetureairport,
                                                     connection~DestinationAirport AS destinationairport  ).

    SELECT FROM zflights_joh
    FIELDS *
    INTO TABLE @DATA(lt_flights).

    IF sy-subrc EQ 0.
      out->write( lt_flights ).
    ELSE.
      out->write( 'INSERT FALLADO'  ).
    ENDIF.







  ENDMETHOD.
ENDCLASS.
