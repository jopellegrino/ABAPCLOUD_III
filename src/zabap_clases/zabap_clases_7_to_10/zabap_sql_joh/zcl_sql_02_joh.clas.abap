CLASS zcl_sql_02_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sql_02_joh IMPLEMENTATION.



  METHOD if_oo_adt_classrun~main.


*    """""INSERT (CON TRATAMIENTO DE EXEPCIONES)

    DATA lt_ddbb TYPE STANDARD TABLE OF zcarrier_joh.

    SELECT FROM /DMO/I_Carrier
    FIELDS AirlineID AS carrier_id,
           name AS namecompany,
           CurrencyCode AS currency_code
    WHERE CurrencyCode = 'USD'
    INTO CORRESPONDING FIELDS OF TABLE @lt_ddbb.

    IF sy-subrc = 0.

      TRY.                                               "INSTRUCCIONES PARA CAPTURAR LA EXCEPCION
          "INSERT zcarrier_joh FROM TABLE @lt_ddbb.       "INSTRUCCION QUE GENERA LA EXCEPCION

        CATCH cx_sy_open_sql_db INTO DATA(lx_sql_db).    "SI SE LEVANTA LA EXCEPCION ESTO ACTUA COMO UN IF = TRUE
          out->write( lx_sql_db->get_text(  ) ).         "IMPRIME EL TEXTO DE LA EXEPCION
          RETURN.                                        "COMO YA NO TIENE SENTIDO SEGUIR SALE DE TODO
      ENDTRY.


      IF sy-subrc = 0.
        out->write( |El numero de registros es { sy-dbcnt } (Part 1) | ).
      ELSE.
        out->write( |No se ha podido insertar los registros (Part 1)| ).
      ENDIF.

    ENDIF.


*    """""INSERT (SIN TRATAMIENTO DE EXEPCIONES)(LAS IGNORA LAS EXCEPCIONES E IGUAL INSERTA)

    SELECT FROM /DMO/I_Carrier
    FIELDS AirlineID AS carrier_id,
           name AS namecompany,
           CurrencyCode AS currency_code
   "WHERE CurrencyCode = 'USD'                                          "GRACIAS A ESTO LOS DE USD ESTARAN DUPLICADOS Y DARA ERROR EL INSERT, YA QUE VENIA LA BBDD CON 5 ROWS CON USD
    INTO CORRESPONDING FIELDS OF TABLE @lt_ddbb.


    INSERT zcarrier_joh FROM TABLE @lt_ddbb ACCEPTING DUPLICATE KEYS.   "ACEPTA QUE HAYA DUPLICADOS, LOS IGNORA Y SOLO INSERT LOS NO DUPLICADOS, A PESAR DE QUE SY-SUBRC DICE LO CONTRARIO, PERO SY-DBCNT DICE LO CORRECTO

    IF sy-subrc = 0.
      out->write( |El numero de registros Insertados es { sy-dbcnt } (Part 2)| ).
    ELSE.
      out->write( |No se ha podido insertar los registros { sy-dbcnt } (Part 2)| ).
    ENDIF.


  ENDMETHOD.
ENDCLASS.
