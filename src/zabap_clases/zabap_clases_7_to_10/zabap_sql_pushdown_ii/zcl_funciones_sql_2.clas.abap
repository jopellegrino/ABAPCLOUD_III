CLASS zcl_funciones_sql_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_funciones_sql_2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""FUNCIONES PARA FECHAS (DATN YYYYMMDD TIPO NATIVO HANA) (DATS YYYYMMDD TIPO FECHA CLASICO) TIENEN DIFERENCIAS EN FUNCIONES

    MODIFY zdmo_exprssn_joh FROM @( VALUE #( id = 'L'
                                             dats1 = '20300101'
                                             dats2 = '20310101'
                                             datn1 = '20400101'
                                             datn2 = '20410101' ) ).

    SELECT SINGLE FROM zdmo_exprssn_joh
    FIELDS id,
           dats1,
           dats2,
           datn1,
           datn2,
           dats_is_valid( dats1 ) AS Valid,                      "COMPROBAR SI LA FECHA ES VALIDA (1=VALID 0=NOVALID) FECHA CLASICO
           dats_days_between( dats1, dats2 ) AS Days_Between_D,  "DEVUELVE EL # DE DIAS EN UN INTERVALO DE FECHA CLASICO

           datn_days_between( datn1, datn2 ) AS Days_Between_N,  "TIPO NATIVO DE HANA, DIAS ENTRE DOS FECHAS

           dats_add_days( dats1, 30 ) AS add_days_d,             "AGREGAR DIAS A UN TIPO FECHA STANDAR
           datn_add_days( datn1, -30 ) AS add_days_n,            "ADD DIAS A TIPO HANA, SE PUEDE SUMAR NUM NEGATIVOS

           dats_add_months( dats1, -2 ) AS add_month_d,          "ADD MESES Y SE PUEDE COLOCAR UN NEGATIVO
           datn_add_months( datn1, 3 )  AS add_month_n,

           dats_from_datn( datn1 ) AS Dats_from_N,               "CONVIERTE DE TIPO HANA A ESTANDAR DE FECHA
           dats_to_datn( dats1 ) AS Dats_to_N                    "CONVIERTE DE FECHA STANDAR A HANA

           WHERE id EQ 'L'
           INTO @DATA(ls_result).

    IF sy-subrc EQ 0.
      out->write( ls_result ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).


*    """""FUNCIONES PARA TIMESTAMP (VAR TIPO FECHA)

    out->write( |FUNCIONES PARA TIMESTAMP | ).

    DATA(lv_seconds) = 3600.

    GET TIME STAMP FIELD DATA(lv_timestamp).        "OBTIENE EL TIMESTAMP EN EL MOMENTO DE EJECUCION

    DELETE FROM zdmo_exprssn_joh.

    INSERT zdmo_exprssn_joh FROM @( VALUE #( id = 'L'
                                             num1 = lv_seconds
                                             timestamp1 = lv_timestamp      ) ).

    TRY.

        SELECT SINGLE FROM zdmo_exprssn_joh
        FIELDS id,
               num1,
               timestamp1,
               tstmp_is_valid( timestamp1 ) AS Valid,                                                                      "VER SI ES UN VALOR VALIDO DE TIMESTAMP

               tstmp_seconds_between( tstmp1 = tstmp_current_utctimestamp(  ),                                             "FUNCION QUE DEVUELVE LOS SEG. ENTRE DOS TIMESTAMP, EL 1ER PARAMETRO TRAE EL TIMESTAMPS ACTUAL
                                      tstmp2 = tstmp_add_seconds( tstmp   = timestamp1,                                    "PARA COMPLICARLO COLOCA UNA FUNCION COMO ARGUMENTO DE OTRA FUNCION, QUE TAMBIEN TIENE SU PROPIO ARGUMENTO
                                                                  seconds = CAST( num1 AS DEC( 15,0 ) ),                   "LA FUNCION DE ADENTRO SOLO SUMA SEGUNDOS, A UN TIMESTAMPS POR ESO SE HACE EL CAST, PERO DEBE SER FIELDS DE LA TABLA
                                                                  on_error = @sql_tstmp_add_seconds=>set_to_null ),

                                       on_error = @sql_tstmp_seconds_between=>set_to_null ) AS Difference           "SI OCURRE UN ERROR Y SOLO HAY EL TRY-ENDTRY, EL PROGRAMA SE TERMINARA, PERO SI HACEMOS ON_ERROR,
            WHERE id EQ 'L'                                                                                         "ASINARA NULL, INITIAL O ETC A ESOS CAMPOS Y CONTINUARA, @sql_tstmp_add_seconds TIENE LOS VALORES ESTATICOS PARA SU ON ERROR
                                                                                                                    "TAMBIEN EXISTEN PARA OTRAS FUNCIONES USANDO SUS NOMBRES EJEMP @SQL_NOMBRE_DE_FUNCION
            INTO @DATA(ls_result_TIMESTMP).                                                                         "EN ON_ERROR (NO RECOMIENDA COLOCAR  1), MEJOR ES NULL, EL ON_ERROR SE USA EN FUNCIONES SQL PUSHDOWN


      CATCH cx_sy_open_sqL_db INTO DATA(lx_sql_db).
        out->write( lx_sql_db->get_text(  ) ).
        RETURN.                                         "CON ESTO SE SALE, YA QUE NO TIENE SENTIDO CONTINUAR CON EL PROGRAMA
    ENDTRY.


    IF sy-subrc EQ 0.
      out->write( ls_result_TIMESTMP ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).

*   """""CONVERSION DE TIMESTAMPS EN TIPO DATE Y TIME

    out->write( |CONVERSION DE TIMESTAMPS -> DATE/TIME | ).

    CONVERT TIME STAMP lv_timestamp
    TIME ZONE 'UTC'      "AL TIPO TIME ZONE QUE SE QUIERE CONVERTIR (SALIDA)
    INTO DATE DATA(lv_date)
         TIME DATA(lv_time).

    out->write( name = 'DATE TSTAMP' data = lv_date ).
    out->write( name = 'TIME TSTAMP' data = lv_time ).

    """""CONVERTIR UTCLONG EN DATE/TIME

    CONVERT UTCLONG CONV utclong( '2030-11-27 09:30:30' )
            INTO DATE lv_date
                 TIME lv_time
            DAYLIGHT SAVING TIME DATA(lv_dst)
            TIME ZONE 'CET'.

    out->write( name = 'DATE UTC' data = lv_date ).
    out->write( name = 'TIME UTC' data = lv_time ).

    out->write( | | ).


*    """""FUNCIONES PARA HUSO HORARIO""""" O TIME ZONE, DE SISTEMA ABAP O USUARIO

    out->write( |TIME ZONE| ).

    SELECT SINGLE FROM zdmo_exprssn_joh
    FIELDS abap_system_timezone( on_error = @sql_abap_system_timezone=>set_to_null ) AS System_TimeZone,    "TIME ZONE DEL SISTEMA, SI HAY ERROR ASIGNA VALOR NULO
           abap_user_timezone( on_error = @SQL_abap_user_timezone=>set_to_null  )    AS User_TimeZone       "TIME ZONE DEL USER, SI HAY ERROR ASIGNA VALOR NULO
    INTO @DATA(lt_huso_horario).

    IF sy-subrc EQ 0.
      out->write( lt_huso_horario ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( |   | ).


*    """""CONVERSIONES DE FECHAS Y TIMESTAMPS

    DELETE FROM zdmo_exprssn_joh.

    INSERT zdmo_exprssn_joh FROM @( VALUE #( id = 'L'
                                             dats1 = '20300101'
                                             tims1 = '103040'               ) ).

    DATA lv_time_zone TYPE timezone.   "DECLARAMOS UNA VAR TIPO TIMEZONE (HUSO HORARIO)

    TRY.

        lv_time_zone = cl_abap_context_info=>get_user_time_zone(  ).   "OBTIENE ZONA HORARIA DEL USARIO

      CATCH Cx_abap_context_info_error INTO DATA(lx_contex_info).
        out->write( lx_contex_info->get_text(  ) ).
        RETURN.

    ENDTRY.

    lv_time_zone = 'CET'.   "CENTRA EUROPEAN TIME, PARA HACER DIFERENCIAS CON EL DST

    SELECT SINGLE FROM zdmo_exprssn_joh
    FIELDS id,
           dats1,
           tims1,
           tstmp_current_utctimestamp(  ) AS Current_UTC,    "DETERMINA EL UTC TIMES STAMP AHORA

           tstmp_to_dats( tstmp    = tstmp_current_utctimestamp(  ),                "CONVIERTE DE TSTMP A DATS
                          tzone    = @lv_time_zone,
                          on_error = @sql_tstmp_to_dats=>set_to_null  ) AS to_dats,

           tstmp_to_tims( tstmp    = tstmp_current_utctimestamp( ),
                          tzone    = @lv_time_zone,
                          on_error = @sql_tstmp_to_tims=>set_to_null   ) AS to_tims,  "CONVIERTE TSTMP A TIMS

           tstmp_to_dst( tstmp    = tstmp_current_utctimestamp( ),
                         tzone    = @lv_time_zone,                                  "DA 'X' SI HAY DIFERENCIAS DE HUSO HORARIO, SI NO HAY DIFERENCIA DA VACIO
                         on_error = @SQL_tstmp_to_dst=>set_to_null ) AS To_DST,     "(DAYLIGHT SAVING TIME (CREO)  ) "INDICA SI EXISTE DIF DE HORARIO EJMPLO VERANO, O ETC, PARA LA ZONA HORARIA ESPECIFICADA, EN TIME ZONE

            dats_tims_to_tstmp( date     = dats1,
                                time     = tims1,
                                tzone    = @lv_time_zone,
                                on_error = @sql_DATS_TIMS_TO_TSTMP=>set_to_null ) AS to_tstmp           "CONVERTIR DE FECHA Y TIEMPO A UN TIMESTAMP

    WHERE id = 'L'
    INTO @DATA(lv_result_time).

    IF sy-subrc EQ 0.
      out->write( lv_result_time ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.



  ENDMETHOD.
ENDCLASS.
