CLASS zcl_7_query_dinamic_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_7_QUERY_DINAMIC_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """""TABLA INTERNA QUE RECIBE LOS DATOS DINAMICAMENTE


    DATA lo_generic_data TYPE REF TO data.          "********NECESARIO PARA VINCULAR EL TIPO A LA ITAB
    FIELD-SYMBOLS <lt_itab> TYPE STANDARD TABLE.    "*******TABLA GENERICA SIN TIPO ASIGNADO



    DATA: lv_datasource_name_2 TYPE string,                             "VAR PARA LA FUENTE DE DATOS DINAMICA
          lv_selected_colums   TYPE string,                             "VAR PARA LAS COLUMNAS DINAMICAS
          lv_where_conditions  TYPE string,                             "VAR PARA LAS CONDICIONES WHERE DINAMICAS
          lv_airline_id        TYPE string.                             "OTRO DATO VARIABLE PARA CONDICION

    DATA lx_dynamic_osql_2 TYPE REF TO cx_root.

    lv_datasource_name_2 = '/DMO/I_Connection'.     "ASIGNACION DEL AFUENTE DINAMICA /DMO/I_FLIGHT O "/DMO/I_Connection



    IF lv_datasource_name_2 EQ '/DMO/I_Connection'.                                             "ASIGNACIONES DEPENDIENDO DE LA CONDICION

      lv_selected_colums = |AirlineId, ConnectionID, DepartureAirport, DestinationAirport|.     "ASIGNACION DINAMICA DE LOS CAMPOS, DEPENDIENDO DE LA FUENTE
      lv_airline_id = 'AA'.                                                                     "ASIGNACION DINAMICA, LUEGO USADA COMO CONDICION

    ELSEIF lv_datasource_name_2 EQ '/DMO/I_FLIGHT'.

      lv_selected_colums = |AirlineID, ConnectionID, FlightDate, Price, CurrencyCode|.          "ASIGNACION DINAMICA DE LOS CAMPOS
      lv_airline_id = 'LH'.

    ENDIF.

    lv_where_conditions = |Airlineid eq '{ lv_airline_id }'|.   "ESTA CONDICION DEPENDE SI ENTRA AL IF O AL ELSEIF.


    TRY.


        DATA(lo_comp_table) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( lv_datasource_name_2 )
                                                                    )->get_components(  ).   "******PERMITE TRABAJAR CON LA CONSTRUCCION DEL TIPO DE MANERA DINAMICA, LLAMADNO A ESTA CLASE, SOBRE OTRA CLASE QUE DA LA DESCRIPCION DE LOS TIPOS
*                                                                                            "******LLAMANDO AL METODO STATICO DESCRIBE_BY_NAME Y SE LE PASA LA VAR FUENTE DE DATOS, QUE DA LOS TIPOS POR EL NOMBRE DE LA FUENTE
*                                                                                            "******LUEGO -> LLAMA A LA PRIMERA CLASE PASADA AL GETCOMPONENT, EL CAST EVITA LAS QUEJAS DEL COMPILADOR
*                                                                                            "******TODO ESTO DEVUELVE LOS COMPONENTES DE LA ITAB DE MANERA DINAMICA

        DATA(lo_struc_type) = cl_abap_structdescr=>create( lo_comp_table ).                  "******PARA OBTENER LOS TIPOS, SE LLAMA A LA MISMA CLASE Y LUEGO AL METODO CREATE Y SE PASA LA REFERENCIA DEL ANTERIOR OBJETO, ESTO DEVUELVE UN ABAP STRUC.

        DATA(lo_table_type) = cl_abap_tabledescr=>create( lo_struc_type ).                   "******DESCRIPCION DE LA TABLA

        CREATE DATA lo_generic_data TYPE HANDLE lo_table_type.                               "*****CREA UN TIPO DE DATO CONFORME A TODO LO CREADO ANTERIORMENTE

        ASSIGN lo_generic_data->* TO <lt_itab>.                                              "CONVIERTE EL PUNTO EN UN TIPO ESPECIFICO DEPENDIENDO DE LA FUENTE




        SELECT FROM (lv_datasource_name_2)
        FIELDS * "(lv_selected_colums)                         "SE PODRIA COLOCAR FIELDS * PARA TRAER TODOS LOS CAMPOS
        WHERE (lv_where_conditions)                         "SE COLOCA LA VARIABLE DINAMICA DEL WHERE
        INTO TABLE @<lt_itab>.               "********SE ASIGNA EL FIELD SYMBOL

      CATCH cx_sy_dynamic_osql_syntax
            cx_sy_dynamic_osql_semantics
            cx_sy_dynamic_osql_error INTO lx_dynamic_osql_2.
        out->write( lx_dynamic_osql_2->get_text(  ) ).
        RETURN.
    ENDTRY.

    IF sy-subrc = 0.
      out->write( lines( <lt_itab> ) ).              "IMPRIME LA CANTIDAD DE LINEAS DE LA ITAB TRAIDAS DE LA BBDD
      out->write( <lt_itab> ).
    ELSE.
      out->write( 'NO DATA' ).
    ENDIF.


  ENDMETHOD.
ENDCLASS.
