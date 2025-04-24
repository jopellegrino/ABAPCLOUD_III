CLASS zcl_lab_08_fieldsymbols_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_08_fieldsymbols_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    """"""1. DECLARACION

    DATA lv_employee TYPE string.                 "DECL. VAR.

    FIELD-SYMBOLS <lfs_employee> TYPE string.     "DECL FIELD-SYM.

    ASSIGN lv_employee TO <lfs_employee>.         "ASIGNACION DEL FIELD-SYM.

    <lfs_employee> = 'Maria'.                     "DAR VALOR AL APUNTADOR

    out->write( lv_employee ).


    """"""2. DECLARACION EN LINEA
    DATA: lt_zemp_logali TYPE SORTED TABLE OF zemp_logali WITH UNIQUE KEY email id name.

    lt_zemp_logali = VALUE #(  ( id = 00001
                                email  = 'Pedroescamoso@gmail.com'
                                 name   = 'Pedro'
                                 fechan = '20241010'
                                 fechaa =  '20230909'
                                 ape1   =  'AD44'
                                 ape2   =  'AB66' )

                                ( id = 00002
                                 email  = 'Maria@gmail.com'
                                 name   = 'Maria'
                                 fechan = '20240403'
                                 fechaa =  '20230911'
                                 ape1   =  'A666'
                                 ape2   =  'AZZ3' )

                                ( id = 00003
                                 email  = 'JoseJose@gmail.com'
                                 name   = 'Jose'
                                 fechan = '20250403'
                                 fechaa =  '20201111'
                                 ape1   =  'A110'
                                 ape2   =  'XYZ1' )

                               ( id = 00004
                                 email  = 'Julian@gmail.com'
                                 name   = 'Julian'
                                 fechan = '20230101'
                                 fechaa =  '20201220'
                                 ape1   =  'AZ20'
                                 ape2   =  'YYY2' ) ).

    MODIFY zemp_logali FROM TABLE @lt_zemp_logali.   "LLENADO DE LA TABLA DE BBDD

    SELECT FROM zemp_logali
    FIELDS *
    INTO TABLE @DATA(lt_zemp_logali_02).



    LOOP AT lt_zemp_logali_02 ASSIGNING FIELD-SYMBOL(<ls_employee>).
      <ls_employee>-email = 'Petro@hotmail.com'.
    ENDLOOP.

    out->write( data = lt_zemp_logali_02 name = 'Modificacion de correo' ).


    """"""3. AÑADIR UN REGISTRO

    APPEND INITIAL LINE TO lt_zemp_logali_02 ASSIGNING FIELD-SYMBOL(<lfs_zemp_02>). "ASIGNACION DEL PUNTERO

    IF sy-subrc = 0.                                                                "VALIDACION DE CORRECTA ASIGNACION

      <lfs_zemp_02> = VALUE #( id = 00005                                           "APPEND SOBRE EL FIELD-SYM
                                   email  = 'Julian@gmail.com'
                                   name   = 'Julian'
                                   fechan = '20180101'
                                   fechaa =  '20191220'
                                   ape1   =  'A200'
                                   ape2   =  'ZZZ2' ).

      out->write( data = lt_zemp_logali_02 name = 'APPEND' ).

      UNASSIGN <lfs_zemp_02>.                                                       "QUITAR ASIGNACION DE FIELD SYM.

    ENDIF.


    """""4. INSERTAR UN REGISTRO

    INSERT INITIAL LINE INTO lt_zemp_logali_02 ASSIGNING FIELD-SYMBOL(<lfs_zemp_03>) INDEX 2.

    IF sy-subrc = 0.

      <lfs_zemp_03> = VALUE #( id = 00002
                                   email  = 'Mariaele@gmail.com'
                                   name   = 'Maria'
                                   fechan = '20140101'
                                   fechaa =  '20161220'
                                   ape1   =  'A666'
                                   ape2   =  'YYZ2' ).

      out->write( data = lt_zemp_logali_02 name = 'INSERT' ).

      UNASSIGN <lfs_zemp_03>.

    ENDIF.


    """""5. LEER REGISTRO

    READ TABLE lt_zemp_logali_02 ASSIGNING FIELD-SYMBOL(<lsf_zemp_read>) WITH KEY id = 3. "LECTURA Y ASIGNACION EN LINEA DEL APUNTADOR

    <lsf_zemp_read>-name = 'Josefino'.                          "MODIFICACION DIRECTA DE LA ITAB CON EL APUNTADOR
    <lsf_zemp_read>-email = 'Fino@hotmail.com'.

    out->write( data = lt_zemp_logali_02 name = 'READ' ).


    """""6. COERCION - CASTEO

    DATA: LV_date TYPE d.
    FIELD-SYMBOLS: <lfs_date_cast> TYPE any.

    LV_date = cl_abap_context_info=>get_system_date( ).

    ASSIGN LV_date TO <lfs_date_cast>.

    out->write( data = <lfs_date_cast> name = 'CAST' ).



  ENDMETHOD.
ENDCLASS.
