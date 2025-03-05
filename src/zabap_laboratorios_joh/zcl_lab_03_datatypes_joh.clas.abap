CLASS zcl_lab_03_datatypes_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_03_datatypes_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

   "1. CONVERSIONES DE TIPO
    DATA: mv_char  TYPE c LENGTH 10 VALUE '12345',
          mv_num   TYPE i,
          mv_float TYPE f.

    out->write( |Char en tipo c: { mv_char } | ).
    mv_num = mv_char.
    out->write( |Char en tipo i: { mv_num } | ).
    mv_float = mv_num.
    out->write( |Char en tipo f: { mv_float } | ).


    "2. TRUNCAMIENTO Y REDONDEO
    DATA: mv_trunc TYPE i,
          mv_round TYPE i.

    mv_float = '123.45'.
    out->write( |Valor en Float f: { mv_float } | ).
    mv_trunc = mv_float.
    out->write( |Valor Truncado: { mv_trunc } | ).
    mv_round = mv_trunc + '0.5'.
    out->write( |Valor Redondeado: { mv_round } | ).


    "3. TIPOS DE DECLARACIONES EN LINEA
    DATA(lv_line) = 'ABAP'.


    "4. CONVERSIONES DEL TIPO FORZADO
    mv_num = CONV i( mv_char ).
    out->write( |Tipo Char Forzado a i: { mv_num } | ).


    "5. CALCULO DE FECHA Y HORA.
    DATA: mv_date_1 TYPE d VALUE '20240101',
          mv_date_2 TYPE d VALUE '20230101',
          mv_days   TYPE i,
          mv_time   TYPE t.

    mv_days = mv_date_1 - mv_date_2.
    out->write( |Numeros de dias: { mv_days } | ).

    out->write( |Fecha DDMMAAAA: { mv_date_1+6(2) }{ mv_date_1+4(2) }{ mv_date_1+0(4) } | ).

    "6. CAMPOS TIMESSTAMP

    DATA: mv_timestamp TYPE utclong.

    mv_timestamp = utclong_current(  ).
    out->write( |Fecha Actual UTCLONG: { mv_timestamp } | ).

    CONVERT UTCLONG mv_timestamp
    TIME ZONE cl_abap_context_info=>get_user_time_zone(  )
    INTO DATE mv_date_2
    TIME mv_time.

    out->write( |Fecha Actual: { mv_date_2 DATE = USER } | ).
    out->write( |Hora Actual: { mv_time TIME = USER } | ).

    mv_timestamp = utclong_add( val = mv_timestamp days = -2 ).
    out->write( |Fecha UTC Menos 2 dias: { mv_timestamp } | ).



  ENDMETHOD.
ENDCLASS.
