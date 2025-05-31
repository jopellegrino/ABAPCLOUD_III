CLASS zcl_lab_06_condition_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_06_CONDITION_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "1. IF / ENDIF
    DATA lv_conditional TYPE i VALUE 7.

    IF lv_conditional EQ 7.
      out->write( |El valor de la variable "lv_conditional" es igual a "7"| ).

    ELSE.
      out->write( |El valor de la variable "lv_conditional" es diferente a "7"| ).

    ENDIF.


    "2. CASE / ENDCASE (NO HAYE INFORMACION SOBRE LA SINTAXIS PARA CREAR UNA
    "SUBRUTINA FORM QUE ME FUNCIONARA, ASI QUE LO REALICE CON UN BUCLE,
    "SI PUDIERA PROPORCIONARME LA INFORMACION SOBRE CREAR UNA SUBRUTINA FORM LO AGRADECERIA

    DATA lv_string TYPE string.

    lv_string = 'LOGALI'.

    DO 3 TIMES.

      IF sy-index = 1.
        lv_string = 'LOGALI'.
      ELSEIF sy-index = 2.
        lv_string = 'SAP'.
      ELSE.
        lv_string = 'Unknown'.

        CASE lv_string.
          WHEN 'LOGALI'.
            out->write( |Academy| ).

          WHEN 'SAP'.
            out->write( |Enterprise software.| ).

          WHEN OTHERS.
            out->write( |Unknown| ).

        ENDCASE.
      ENDIF.
    ENDDO.


    "3. DO / ENDDO

    DATA lv_counter TYPE i.

    DO 10 TIMES.

      lv_counter += 1.
      out->write( |Valor de "lv_counter": { lv_counter }| ).

    ENDDO.


    "4. CHECK

    lv_counter = 0.

    DO.

      lv_counter += 1.
      out->write( |Valor de "lv_counter" con "check" : { lv_counter }| ).

      CHECK lv_counter = 7.
      EXIT.

    ENDDO.


    "5. SWITCH

    DATA lv_string_2 TYPE string.

    DO 4 TIMES.

      IF sy-index = 1.
        lv_string_2 = 'LOGALI'.
      ELSEIF sy-index = 2.
        lv_string_2 = 'SAP'.
      ELSEIF sy-index = 3.
        lv_string_2 = 'MOVISTAR'.
      ELSE.
        lv_string_2 = 'N/A'.
      ENDIF.

      DATA(lv_value) = SWITCH #( lv_string_2
                                 WHEN 'LOGALI' THEN |SAP Academy|
                                 WHEN 'SAP' THEN |Enterprise software|
                                 WHEN 'MOVISTAR' THEN |Telephony|
                                 ELSE |Unknown| ).
      out->write( |SWITCH: { lv_value }| ).

    ENDDO.

    "6. COND

    DATA lv_time TYPE t.
    lv_time = cl_abap_context_info=>get_system_time( ).

    DATA(lv_cond_time) = COND #( WHEN lv_time < '120000' THEN | { lv_time } AM|
                                 WHEN lv_time > '120000' THEN |{ CONV t( lv_time - 12 * 3600 ) TIME = ISO } PM|
                                 WHEN lv_time = '120000' THEN |High Noon|
                                 ELSE |Tiempo sin identificar|     ).

    out->write( |Hora Actual: { lv_cond_time }| ).


    "7. WHILE / ENDWHILE

    DATA lv_counter_2 TYPE i.

    WHILE lv_counter_2 < 20.

      lv_counter_2 += 1.
      out->write( |El valor de la variable lv_counter_2: { lv_counter_2 } | ).

      IF lv_counter_2 LE 10.
        out->write( |Valores menores a diez: { lv_counter_2 } | ).
      ENDIF.

    ENDWHILE.


    "8. LOOP / ENDLOOP


    "SELECT FROM zemp_logali
    "FIELDS ape2, email
    "INTO TABLE @DATA(lt_employees).

    "LOOP AT lt_employees INTO DATA(ls_employees).

     " IF ls_employees-ape2 EQ 'JIMENEZ'.

      "  out->write( |Correo: { ls_employees-email } | ).

      "ENDIF.
    "ENDLOOP.


    "9. TRY / ENDTRY

    DATA lv_exception TYPE f VALUE 5.
    lv_counter = 5.

    TRY.
        DO 5 TIMES.

          lv_counter = lv_counter - 1.
          DATA(lv_div) = lv_exception / lv_counter.
          out->write( |El valor de la division es: { lv_div }| ).

        ENDDO.
      CATCH cx_sy_zerodivide  INTO DATA(lx_zero_div).
        out->write( |Error: Se ha detectado una division por cero | ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
