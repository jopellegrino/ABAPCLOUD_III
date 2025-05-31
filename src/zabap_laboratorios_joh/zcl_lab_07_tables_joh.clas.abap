CLASS zcl_lab_07_tables_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_07_TABLES_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: mt_employees TYPE STANDARD TABLE OF zemp_logali,
          ms_employees TYPE zemp_logali.


    "1. AÑADIR REGISTROS
    ms_employees = VALUE #( id     = 8910
                              email  = 'deidominguez@gmail.com'
                              name   = 'Dey'
                              fechan = '20251112'
                              fechaa = '20250909'
                              ape1   = 'B23'
                              ape2   = 'B24' ).

    mt_employees = VALUE #( ( id     = 4567
                              email  = 'perezjose@gmail.com'
                              name   = 'Jose'
                              fechan = '20251010'
                              fechaa = '20250909'
                              ape1   = 'B23'
                              ape2   = 'B24'   )

                            ( id        = 1234
                              email     = 'petraramirez@gmail.com'
                              name      = 'Petra'
                              fechan    = '20251111'
                              fechaa    = '20250707'
                              ape1      = 'B23'
                              ape2      = 'B24'   )            ).

    APPEND VALUE #(           id     = 11111
                              email  = 'jesusandrade@gmail.com'
                              name   = 'Jesus'
                              fechan = '20241010'
                              fechaa = '20230909'
                              ape1   = 'B03'
                              ape2   = 'B04'  ) TO mt_employees.




    out->write( EXPORTING data = mt_employees name = 'mt_employees (VALUE)(APPEND)' ).
    out->write( EXPORTING data = ms_employees name = 'ms_employees (VALUE)' ).


    "2. INSERTAR REGISTROS

    INSERT VALUE #(  id     = 22222
                     email  = 'Emanuelandrade@gmail.com'
                     name   = 'Emanuel'
                     fechan = '20241010'
                     fechaa = '20210909'
                     ape1   = 'B93'
                     ape2   = 'B94' ) INTO TABLE mt_employees.

    out->write( EXPORTING data = mt_employees name = 'ms_employees (INSERT)' ).


    "3. AÑADIR REGISTROS CON APPEND

    DATA mt_employees_2 TYPE STANDARD TABLE OF zemp_logali.

    APPEND ms_employees TO mt_employees_2.

    APPEND VALUE #(           id     = 22222
                              email  = 'pirulopereze@gmail.com'
                              name   = 'Pirulo'
                              fechan = '20201010'
                              fechaa = '20200909'
                              ape1   = 'B44'
                              ape2   = 'B55'  ) TO mt_employees_2.

    APPEND LINES OF mt_employees FROM 2 TO 3 TO mt_employees_2.

    out->write( EXPORTING data = mt_employees_2 name = 'ms_employees (APPEND 2)' ).


    "4. CORRESPONDING

    DATA: mt_spfli   TYPE STANDARD TABLE OF /dmo/connection,
          ms_spfli   TYPE /dmo/connection,
          ms_spfli_2 TYPE /dmo/connection.

    SELECT FROM /dmo/connection
    FIELDS *
    WHERE carrier_id = 'LH'
    INTO TABLE @mt_spfli.


    READ TABLE mt_spfli INTO ms_spfli INDEX 1.              "ASIGNACION DEL PRIMER REGISTRO A ms_spfli

    MOVE-CORRESPONDING ms_spfli TO ms_spfli_2.

    out->write( EXPORTING data = mt_spfli name = 'MT_SPFLI' ).
    out->write( EXPORTING data = ms_spfli_2 name = 'MS_SPFLI_2' ).



    "5. READ TABLE CON INDICE

    "FORMA 1
    READ TABLE mt_spfli INTO DATA(lv_spfli) INDEX 1 TRANSPORTING airport_from_id.
    out->write( data = lv_spfli name = 'READ TABLE CON INDICE' ).

    "FORMA 2
    DATA(lv_spfli_2) = mt_spfli[ 1 ]-airport_from_id.
    out->write( data = lv_spfli_2 name = 'READ TABLE CON INDICE (2)' ).


    "6. READ TABLE CON CLAVE

    "FORMA 1
    READ TABLE mt_spfli INTO lv_spfli WITH KEY airport_from_id = 'FRA' TRANSPORTING airport_to_id.
    out->write( data = lv_spfli name = 'READ TABLE CON KEY' ).

    "FORMA 2
    DATA(asd) = mt_spfli[ airport_from_id = 'FRA' ]-airport_to_id.
    out->write( data = lv_spfli_2 name = 'READ TABLE CON KEY (2)' ).


    "7. CHEQUEO DE REGISTROS

    SELECT FROM /dmo/connection
    FIELDS *
    WHERE connection_id >= 0401
    INTO TABLE @mt_spfli.

    "FORMA 1
    READ TABLE mt_spfli WITH KEY connection_id = '0407' TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.
      out->write( 'El valor connection_id = "0407", existe' ).
    ELSE.
      out->write( 'El valor connection_id = "0407", NO existe' ).
    ENDIF.

    "FORMA 2

    IF line_exists( mt_spfli[ connection_id = '0407' ] ).
      out->write( 'El valor connection_id = "0407", existe' ).
    ELSE.
      out->write( 'El valor connection_id = "0407", NO existe' ).
    ENDIF.

    "8. INDICE DE UN REGISTRO
    READ TABLE mt_spfli WITH KEY connection_id = '0407' TRANSPORTING NO FIELDS.

    "FORMA 1
    DATA(lv_index) = sy-tabix.
    out->write( |El indice de el registro consultado es:  { lv_index }| ).

    "FORMA 2
    lv_index = line_index( mt_spfli[ connection_id = '0407' ] ).
    out->write( |El indice de el registro consultado es:  { lv_index }| ).


    "SENTENCIA LOOP

    SELECT FROM /dmo/connection
    FIELDS *
        INTO TABLE @mt_spfli.

    LOOP AT mt_spfli INTO DATA(LV_mt_spfli2) WHERE distance_unit = 'KM'.
      out->write( data = LV_mt_spfli2 ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
