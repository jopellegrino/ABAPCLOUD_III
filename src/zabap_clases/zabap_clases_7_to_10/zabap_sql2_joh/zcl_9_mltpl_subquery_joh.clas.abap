CLASS zcl_9_mltpl_subquery_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_9_MLTPL_SUBQUERY_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*  """""LLENAR CARRIER_JOH

    DATA lt_carrier_fill TYPE STANDARD TABLE OF zcarrier_joh.

    DELETE FROM zcarrier_joh.

    SELECT FROM /dmo/carrier
    FIELDS carrier_id,
           currency_code,
           name AS namecompany
    INTO CORRESPONDING FIELDS OF TABLE @lt_carrier_fill.

    INSERT zcarrier_joh FROM TABLE @lt_carrier_fill.



*  """""SUBQUERY EXISTS""""" CONDICION DE COMPROBACION SI EXISTE EL REGISTRO EN OTRA FUENTE ADICIONAL

    out->write( |"""""SUBQUERY EXISTS"""""| ).   "VERIFICA SI LA SUBCONSULTA DEVUELVE AL MENOS UNA FILA, MEJOR PARA GRANDES VOLÚMENES

    SELECT FROM /dmo/i_flight AS flight
    FIELDS *
    WHERE OccupiedSeats < flight~MaximumSeats         "COMO SE ESTAN COMPARANDO DOS CAMPOS DIFERENTES DEBE USAR UN ALIAS PARA LA TABLA FUENTE Y APLICARLA SOBRE EL CAMPO
          AND EXISTS ( SELECT FROM zcarrier_joh       "SI EXISTE EL CODIGO EN LA TABLA SECUN. IGUAL A LA PRIMARIA QUIERO QUE TENGAS EN CUENTA ESE REGISTRO EN LA TABLA PRINCIPAL Y TRAELO
                       FIELDS *
                       WHERE carrier_id EQ flight~AirlineID    ) "ESTO NO COMPARA CON UNA COLUMNA, LO HACE CON UN REGISTRO ENTERO, TAMBIEN SE PUEDE COLOCAR UN CAMPO, AL FINAL SOLO DEVUELVE TRUE O FALSE TODA LA SUBQUERY
    INTO TABLE @DATA(lt_flights).                                "TODO ESTO SIGNIFICA QUE TRAE TODOS LOS REGISTROS DE CARRIERID DE BBDD "A" QUE EXISTEN EN BBDD "B" Y QUE TENGAN ASIENTOS DISPONIBLES ASIENTOSTOTAL > ANSIENTOOCUPADO

    IF sy-subrc EQ 0.
      out->write( lt_flights ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).


*   """""SUBQUERY IN"""""""SELECCIONAR TODOS LOS VUELOS CUYA CONEXION EXISTE EN LA SUBQUERY

    out->write( |"""""SUBQUERY IN"""""""| ).  "VERIFICA SI UN VALOR ESTÁ DENTRO DE UNA LISTA O RESULTADO DE SUBCONSULTA, BUENO SI LA LISTA ES PEQUEÑA

    SELECT FROM /dmo/i_flight AS flight
    FIELDS *
    WHERE AirlineID IN ( SELECT FROM /DMO/I_Connection
                               FIELDS AirlineID
                               WHERE AirlineID    EQ  flight~AirlineID        "USA DOS FUENTES QUE TIENEN EN COMUN AIRLINEID Y CONNECTIONID
                                 AND ConnectionID EQ  flight~ConnectionID )   "COMPARA LOS DOS CAMPOS QUE ESTAN EN LA SEGUNDA FUENTE Y EN LA PRIMERA Y TRAE LOS REGISTROS DE LA PRIMERA
    INTO TABLE @DATA(lt_flights_2).                                                                          "COMO ESTE SELECT TRAE MULTIPLES REGISTROS EL IN, SIGNIFICA QUE ESTAN DENTRO ES PARECIDO A UN EQ O EXIST

    IF sy-subrc EQ 0.
      out->write( lt_flights_2 ).
    ELSE.
      out->write( |NO DATA| ).
    ENDIF.

    out->write( | | ).





  ENDMETHOD.
ENDCLASS.
