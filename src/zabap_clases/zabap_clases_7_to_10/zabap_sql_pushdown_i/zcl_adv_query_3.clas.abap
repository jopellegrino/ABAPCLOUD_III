CLASS zcl_adv_query_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_adv_query_3 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""DATABASE HINTS"""""(SE DESEA QUE HAGA LA SELECCION USANDO LOS INDEX (EL OBJ DE DICCIONARIO) CREADOS DE LA TABLA DE BBDD)

    out->write( |"""""DATA BASE HINTS (INDEX)""""" | ).

    TRY.

        SELECT FROM zdbt_invoice_joh    "ESTA TABLA TIENE EN SU CONFIG. UN TABLE INDEX EN EL DICC
        FIELDS *
        %_HINTS HDB 'INDEX_SEARCH'      "HDB HANA DATA BASE, BUSQUEDA UTIL CUANDO NO APLICAS WHERE
        INTO TABLE @FINAL(lt_invoices). "FINAL SOLO HACE QUE NO SE PUEDA REASIGNAR MAS DATOS O CAMBIAR LOS QUE TIENE EN LA VARIABLE, ASGINACION UNICA

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql_db).

        out->write( lx_sql_db->get_text(  ) ).

    ENDTRY.

    IF sy-subrc EQ 0.
      out->write( lt_invoices ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*   """""UNION""""" (PERMITE SELECT DATOS DE MULTIPLES FUENTES, SEAN DUPLICADOS O CON DISTINCT (LOS NO DUPLICADOS LOS PRIMEROS)

    out->write( |"""""UNION"""""| ). "GENERA UNA TABLA EMPALMANDO LOS DATOS DE LA FUENTE 1, CON LOS DATOS DE LA FUENTE 2

    CONSTANTS lc_blank_date TYPE d VALUE '00000000'.

    SELECT FROM /dmo/i_flight             "NO PERMITE SELECT SINGLE
    FIELDS AirlineID AS id,               "NO PERMITE UN ORDER BY PRIMARY KEY, NI UP TO ... ROWS
           ConnectionID,
           FlightDate

    UNION ALL                             "NO TOMA EN CUENTA QUE ESTEN DUPLICADO, PARA SIN DUPLICADOS
    "UNION DISTINCT                       "SIN DUPLICADOS

    SELECT FROM  /DMO/I_Connection        "DEBE TENER EL MISMO NUM DE COLUMNAS EN TODAS LAS SELECCIONES
    FIELDS AirlineID AS id,               "DEBEN SER EL MISMO NOMBRE DE LOS CAMPOS EN AMBOS SELECT
           ConnectionID,                  "DEBEN TENER EL MISMO TIPO DE DATO, SE PUEDE USAR UN CAST
           @lc_blank_date AS FlightDate   "COMO DEBEN DE TENER EL MISMO # DE COLUMNAS SE COLOCA UNA EN BLANCO PARA COMPLETAR

    INTO TABLE @DATA(lt_union_all).

    IF sy-subrc EQ 0.
      out->write( lt_union_all ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( cl_abap_char_utilities=>newline ).


    """""UNION DE MULTIPLES FUENTES DE DATOS"""""

    SELECT FROM /dmo/i_flight
    FIELDS AirlineID AS id,
       ConnectionID

    UNION DISTINCT

    SELECT FROM  /DMO/I_Connection
    FIELDS AirlineID AS id,
       ConnectionID

    UNION DISTINCT

 (  SELECT FROM /dmo/i_flight
    FIELDS AirlineID AS id,
           ConnectionID

    UNION ALL

    SELECT FROM  /DMO/I_Connection
    FIELDS AirlineID AS id,
           ConnectionID )

    INTO TABLE @DATA(lt_union_mix).


*   """""INTERSECT - INTERSECT DISTINCT (INTERSECCION DE MULTIPLES FUENTES DE DATOS, DIFERENTE DE INNER JOIN EN QUE ES SIN CONDICION ON, PERO SE PARECEN)

    out->write( |"""""INTERSECT"""""| ).

    DELETE FROM ztable1_joh.
    INSERT ztable1_joh FROM TABLE @( VALUE #(
                                            ( a = 'a1' b = 'b1' c = 'c1' d = 'd1' )             "PRIMERA Y SEGUNDA TABLA CON REGISTROS IGUALES PERO CAMPOS DISTINTOS
                                            ( a = 'a2' b = 'b2' c = 'c2' d = 'd2' )             "TERCERA TABLA SOLO EL PRIMER REGISTROS IGUALES, Y EL SEGUNDO Y TERCERO DIFERENTE
                                            ( a = 'a3' b = 'b3' c = 'c3' d = 'd3' ) ) ).

    DELETE FROM ztable2_joh.
    INSERT ztable2_joh FROM TABLE @( VALUE #(
                                            ( d = 'a1' e = 'b1' f = 'c1' g = 'd1' )
                                            ( d = 'a2' e = 'b2' f = 'c2' g = 'd2' )
                                            ( d = 'a3' e = 'b3' f = 'c3' g = 'd3' ) ) ).

    DELETE FROM ztable3_joh.
    INSERT ztable3_joh FROM TABLE @( VALUE #(
                                            ( i = 'a1' j = 'b1' k = 'c1' l = 'd1' )
                                            ( i = 'i1' j = 'j1' k = 'k1' l = 'l1' )         "=/
                                            ( i = 'i2' j = 'j2' k = 'k2' l = 'l2' ) ) ).    "=/


    """""ACTUA MUESTRANDO LOS REGISTROS QUE APARECEN EN AMBAS FUENTES ( A PESAR DE QUE LOS CAMPOS SE LLAMAN DISTINTOS CON EL AS SE ARREGLA)
    SELECT FROM ztable1_joh     "REGLAS IGUALES A LAS UNIONES
    FIELDS  a AS c1,
            b AS c2,
            c AS c3,
            d AS c4

      INTERSECT

    SELECT FROM ztable2_joh
    FIELDS d AS c1,
           e AS c2,
           f AS c3,
           g AS c4
    INTO TABLE @DATA(lt_intersect).

    IF sy-subrc EQ 0.
      out->write( lt_intersect ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


    """""(ESTE EJEMPLO NO ES ILUSTRATIVO DE ESTE CASO PERO HACE LO MISMO QUE INTERSECT PERO SI EXISTE UN REGISTRO DUPLICADO EN LAS 3 TABLAS ENTONCES TRAERIA SOLO UNO
    "INTERSECT DISTINCT
    SELECT FROM ztable1_joh     "REGLAS IGUALES A LAS UNIONES
FIELDS  a AS c1,
        b AS c2,
        c AS c3,
        d AS c4

  INTERSECT

SELECT FROM ztable2_joh
FIELDS d AS c1,
       e AS c2,
       f AS c3,
       g AS c4

 INTERSECT DISTINCT

  SELECT FROM ztable3_joh
FIELDS i AS c1,
       j AS c2,
       k AS c3,
       l AS c4

INTO TABLE @DATA(lt_intersect_2).

    IF sy-subrc EQ 0.
      out->write( lt_intersect ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*    """""INTERSECT CON AGREGACIONES (SE PUEDE USAR DOS FUENTES AQUI USO UNA PORQUE NO TENGO OTRA TAB)

    SELECT FROM /DMO/I_Flight
    FIELDS AirlineID,
           ConnectionID,
           OccupiedSeats
    WHERE AirlineID EQ 'LH'

    INTERSECT

    SELECT FROM /DMO/I_Flight                   "SE AGREGA LOS RESULTADOS DE UNA FUENTE, Y EL AGREGADO SE APLICA UNA INTERSECCION CON OTRA FUENTE
    FIELDS AirlineID,                           "TODO ESE SELECT AGRAGADO ES UNA TAB, Y SE INTERSECTA LA TABLA ORIGINAL ARRIBA
           ConnectionID,
           MAX( OccupiedSeats ) AS OccupiedSeats
    WHERE AirlineID EQ 'LH'
    GROUP BY AirlineID, ConnectionID
    ORDER BY  AirlineID, ConnectionID, OccupiedSeats

    INTO TABLE @FINAL(lt_results_aggr).

    IF sy-subrc EQ 0.
      out->write( name = 'INTERSECT AGREGACIONES' data  = lt_results_aggr ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*   """""EXCEPT"""""CLAUSULA PERMITE APLICAR LAS QUERYS EN BASE A LAS EXCEPCIONES DESDE LAS FUENTES QUE ESTAN DESPUES DE LA CLAUSULA
    "TENER DE LA PRIMERA TAB SOLO AQUELLOS REGISTROS QUE NO APARECEN EN LA TERCERA

    out->write( |"""""EXCEPT"""""| ).

    SELECT FROM ztable1_joh             "DAME TODOS LOS REGISTROS DE ESTA FUENTE...
    FIELDS a AS c1,
           b AS c2,
           c AS c3,
           d AS c4

           EXCEPT   "TAMBIEN PUEDE EXCEPT DISTINCT

    SELECT FROM ztable3_joh             "QUE NO ESTAN EN ESTA FUENTE
    FIELDS i AS c1,
           j AS c2,
           k AS c3,
           l AS c4
    INTO TABLE @FINAL(lt_result_excpt).

    IF sy-subrc EQ 0.
      out->write( lt_result_excpt ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
