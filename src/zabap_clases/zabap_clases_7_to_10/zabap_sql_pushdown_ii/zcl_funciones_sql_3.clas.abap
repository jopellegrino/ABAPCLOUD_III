CLASS zcl_funciones_sql_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_funciones_sql_3 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""CONVERSIONES (IMPORTES(MONEDA) Y CANTIDADES(UNIDADES))

    CONSTANTS lc_currency TYPE c LENGTH 5 VALUE 'EUR'.  "CONVERSION, PODRIA USARSE TIPO CUKY

    DELETE FROM zdmo_exprssn_joh.

    INSERT zdmo_exprssn_joh FROM @(  VALUE #( id     = 'L'
                                              dec3   = '160.934'
                                              amount = '100.00'
                                              currency = 'USD'         ) ).

    TRY.

        SELECT SINGLE FROM zdmo_exprssn_joh
        FIELDS id,
                amount,
               dec3 AS CurrentQuantity,

               'MI' AS CurrentUnit,      "UNIDAD DE MEDIDA MILLAS, UNIDAD INICIAL Y COLOCADA COMO CAMPO EN LOS REGISTROS DE LA ITAB
               'KM' AS ConvertedUnit,     "UNIDAD DE FINAL, Y COLOCADA COMO CAMPO LITERAL EN LA ITAB


               unit_conversion( quantity    = dec3,                                "CONVERTIR UNIDADES, AQUI VA LA CANTIDAD A CONVERTIR
                                source_unit = unit`KM`,                            "UNIDAD INICIAL (ESO QUE SE HIZO ES UN CASTEO, TAMBIEN ASI CAST('KM') AS UNIT, QUE SOLO ACEPTA TIPO UNIT DEL DIC.DE DATOS
                                target_unit = unit`MI`,                            "UNIDAD FINAL
                                on_error = @sql_unit_conversion=>c_on_error-set_to_null ) AS ConvertedQuantity,    "SI ALGUN REGISTRO DA ERROR SE ASGINARA NULL

               currency_conversion( amount          = amount,                                            "CANTIDAD A CONVERTIR
                                    source_currency = currency,                                          "MONEDA INICIAL, COLUMNA
                                    target_currency = @lc_currency,                                      "MONEDA FINAL
                                    exchange_rate_date = @( cl_abap_context_info=>get_system_date( ) ),  "FECHA EN LA CUAL SE SABE LA TASA DE CONVERSION A USAR, REGULARMNETE HOY, ESTO DEBE ESTAR CONFIG. LA TASA DE CONVERSION NO POR DEV
                                    round = 'X',                                                                "SI COLOCAMOS UN ON_ERROR NO SALTA EL TRYCATCH POR ENDE NO VEMOS EL MSJ DE ERROR
                                    on_error = @SQL_currency_conversion=>c_on_error-set_to_null ) AS ConvertedAmount,                 "REDONDEO, HAY QUE COLOCAR EL ON_ERROR Y EL TRY-ENDTRY YA QUE SI NO ESTA CONFIG LA TASA DE CONVERSION DARA ERROR TODO

              @lc_currency AS ConvertedCurrency

               WHERE id EQ 'L'
               INTO @DATA(lv_result).

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql_db).
        out->write( lx_sql_db->get_text(  ) ).
        RETURN.
    ENDTRY.

    IF sy-subrc EQ 0.
      out->write( lv_result ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).

*    """""EXTRACIONES DE PROPIEDADES DE FECHAS (UTCLONG AÑO/MES/DIA/HORA/MIN/SEG./NOMBREMES/NOMBREDIA/#SEMANA)

    out->write( | EXTRACIONES DE PROPIEDADES DE FECHAS | ).

    DELETE FROM zdmo_exprssn_joh.                 "TIPO TIMESTAMP = 20240101103027, TIPO UTCLONG = 2024-01-01T10:30:27

    INSERT zdmo_exprssn_joh FROM @( VALUE #( id = 'L'
                                             dats1 = `20400101`
                                             utcl1 = `2024-01-01T10:30:27`                    ) ).

    SELECT SINGLE FROM zdmo_exprssn_joh
           FIELDS id,
                  dats1,
                  utcl1,

                  extract_year( dats1 )  AS Year_D,          "EXTRAE EL AÑO A UN TIPO FECHA (DATS) Y UN UTCLONG
                  extract_month( dats1 ) AS Month_D,
                  extract_day( dats1 )   AS Day_D,

                  extract_year( utcl1 )   AS Year_UTC,       "ESTOS EXTRAEN NUMEROS
                  extract_month( utcl1 )  AS Month_UTC,
                  extract_day( utcl1 )    AS Day_UTC,
                  extract_hour( utcl1 )   AS Hour_UTC,
                  extract_minute( utcl1 ) AS Min_UTC,
                  extract_second( utcl1 ) AS Sec_UTC,

                  monthname( dats1 ) AS MonthName_D,    "NOMBRE DEL MES
                  dayname( dats1 )   AS DayName_D,      "NOMBRE DEL DIA
                  weekday( dats1 )   AS WeekDay_D,      "EXTRA EL DIA DE LA SEMANA NUMERICO (0,1,2,3,4,5,6)

                  monthname( utcl1 ) AS MonthName_UTC,  "TAMBIEN ACEPTAN TIPO UTCLONG
                  dayname( utcl1 )   AS DayName_UTC,
                  weekday( utcl1 )   AS WeekDay_UTC

                  WHERE id EQ 'L'
                  INTO @FINAL(lv_result_2).

    IF sy-subrc EQ 0.
      out->write( lv_result_2 ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*    """""UUID (UNIVERSAL UNIQUE IDENTIFIER) (CON EL UUID YA NO NECESITAS MAS CAMPOS KEY)

    out->write( 'UUID' ).

    DELETE FROM zflights_joh.
    INSERT zflights_joh FROM ( SELECT FROM /dmo/i_flight                              "LLENANDO MI TABLA DE BBDD A PARTIR DE UNA CDS
                                      FIELDS uuid(  ) AS flight_uuid,                 "ES UNA FUNCION QUE CREA LOS IDENTIFICADORES UNICOS (UUID) PARA LLENAR LA TABLA DE BBDD
                                                         AirlineId,
                                                         ConnectionID,
                                                         FlightDate,
                                                         \_Connection-DepartureAirport,                 "FORMA DE ACCEDER A UN CAMPO QUE TIENE UNA ASOCIACION EN /dmo/i_flight, OSEA MAS CAMPOS
                                                         \_Connection-DestinationAirport  ).            "CLASE PATHEXPRESSION

    SELECT FROM zflights_joh
    FIELDS *
    INTO TABLE @DATA(lt_flight).

    IF sy-subrc EQ 0.
      out->write( lt_flight ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.





  ENDMETHOD.
ENDCLASS.
