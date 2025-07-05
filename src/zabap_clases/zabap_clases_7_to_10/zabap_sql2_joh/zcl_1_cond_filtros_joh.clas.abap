CLASS zcl_1_cond_filtros_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_1_cond_filtros_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*   """""OPERADORES BINARIOS
    "EQ --- =  --- EQUAL
    "NE --- <> --- NOT EQUAL
    "LT --- <  --- LESS THAN
    "LE --- <= --- LESS EQUAL
    "GT --- >  --- GREATER THAN
    "GE --- >= --- GREATER EQUAL


    SELECT FROM zflight_joh
    FIELDS *
    WHERE airline_id = 'AA'
    INTO TABLE @DATA(lt_flight).

    IF sy-subrc EQ 0.
      out->write( lt_flight ).
      out->write( | | ).
    ENDIF.


*    """""BETWEEN (CON OPERADORES BINARIOS)

    SELECT FROM zflight_joh
    FIELDS *
    WHERE  flight_date GE '20250101'    "SE TRAE LOS VUELOS ENTRE DOS FECHAS
       AND flight_date LE '20251231'
    INTO TABLE @lt_flight.

    IF sy-subrc EQ 0.
      out->write( lt_flight ).
      out->write( | | ).
    ENDIF.


*    """""BETWEEN

    SELECT FROM zflight_joh
    FIELDS *
    WHERE flight_date BETWEEN '20250101' AND '20251231'  "SE TRAE LOS VALORES DENTRO DEL RANGO
    INTO TABLE @lt_flight.

    IF sy-subrc EQ 0.
      out->write( lines( lt_flight ) ). "MUESTRA LA CANTIDAD DE REGISTROS QUE TIENE LA ITAB
      out->write( | | ).
    ENDIF.


*   """""NOT BETWEEN

    SELECT FROM zflight_joh
    FIELDS *
    WHERE flight_date NOT BETWEEN '20250101' AND '20251231'  "SE TRAE LOS VALORES FUERA DEL RANGO
    INTO TABLE @lt_flight.

    IF sy-subrc EQ 0.
      out->write( data = lt_flight name = 'NOT BETWEEN' ). "MUESTRA LOS REGISTROS QUE TIENE LA ITAB, FUERA DEL RANGO
      out->write( | | ).
    ENDIF.


*   """""LIKE (PERMITE USAR CARACTERES COMODINES PARA BUSQUEDAS FELIXBLES EN CONSULTAS DE BBDD) (NO RECOMENDABLE EN CLOUD)

    out->write( |"""""LIKE""""" | ).

    DATA lv_search_criteria TYPE string VALUE 'Berlin%'.   "EL % SIGNIFICA QUE PUEDE HABER UNA CADENA DE CARACTERES LUEGO DE Berlin

    SELECT FROM /dmo/i_airport
           FIELDS *
           WHERE name LIKE @lv_search_criteria             "EL LIKE ES PARA USAR LOS COMODINES EN LA BUSQUEDA, Y NO UNA IGUALDAD EXACTA
           INTO TABLE @DATA(lt_airport).

    IF sy-subrc EQ 0.
      out->write( lt_airport ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


    """""LIKE OTRO

    out->write( |"""""LIKE 2""""" | ).
    lv_search_criteria = '_erlin%'.     "SI NO SABES CUAL ES EL PRIMER CARACTER SE COLOCA E "B"erlin, _ REPRESENTA UN SOLO CHAR

    SELECT FROM /dmo/i_airport
           FIELDS *
           WHERE name LIKE @lv_search_criteria
           INTO TABLE @lt_airport.

    IF sy-subrc EQ 0.
      out->write( lt_airport ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.

    out->write( | | ).


*   """""CARACTERES DE ESCAPE PARA LIKE""""" (CUANDO QUIERES BUSCAR EL MISMO SIMBOLO DE PORCENTAJE % O ALGUN OTRO RESERVADO).

    out->write( |"""""ESCAPE PARA LIKE"""""| ).

*    SELECT FROM zcarrier_joh
*    FIELDS *
*    WHERE currency_code = 'USD'
*    INTO TABLE @DATA(lt_airlines).
*
*
*    IF sy-subrc = 0.
*
*      LOOP AT lt_airlines ASSIGNING FIELD-SYMBOL(<lfs_airlines>).
*        <lfs_airlines>-namecompany = |New %: { <lfs_airlines>-namecompany } |.    "ESTO CONCATENA NEW %: CON EL NAMECOMPANY ANTERIORES EN TODOS LOS REGISTROS
*      ENDLOOP.
*
*      UPDATE zcarrier_joh FROM TABLE @lt_airlines.                                "ACTUALIZA TODOS LOS DATOS ASIGNADOS ANTERIORES PERO EN LA BBDD
*
*    ELSE.
*      out->write( |NO DATA| ).
*    ENDIF.

    CONSTANTS cv_escape TYPE c LENGTH 1 VALUE '#'.

    SELECT FROM zcarrier_joh
           FIELDS *
           WHERE namecompany LIKE '%#%%' ESCAPE @cv_escape   "ESTO INDICA QUE EL CARACTER DE ESCAPE (LA CONSTANTE) QUE LO QUE LE SIGUE ES UN VALOR LITERAL QUE QUIERO INCLUIR EN LA QUERY OSEA UN %
           INTO TABLE @DATA(lt_airlines).                    "EL PRIMER % ES UN PREFIJO Y EL ULTIMO ES UN SUFIJO DE CUALQUIER CHAR, Y EL CENTRO ES UN % LITERAL
                                                             "ESTA QUERY SE TRAE TODOS LOS NEW %: ...
    IF sy-subrc = 0.
      out->write( lt_airlines ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
