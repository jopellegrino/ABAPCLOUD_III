CLASS zcl_abap_dd_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

*   "SECUNDARY KEY
    TYPES: BEGIN OF ty_employee_SKEY,
             employee_id TYPE c LENGTH 10,
             first_name  TYPE zde_first_name_joh,
             last_name   TYPE zde_last_name_joh,
             start_date  TYPE zde_start_date_joh,
             category    TYPE zde_job_category_joh,
             status      TYPE c LENGTH 1.
             INCLUDE     TYPE   zst_empl_address_joh.   "TIPO STRUC.
    TYPES: END OF ty_employee_SKEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAP_DD_JOH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*   "ELEMENTO DE DATO Y DOMINIO (DEL DIC. DE DATOS)

    DATA lv_first_name TYPE zde_first_name_joh.   "ASIGNACION DE UN ELEMENTO DE DATOS DEL DICCIONARIO A UNA VAR
    lv_first_name = 'Primer Nombre'.


*   "ESTRUCTURA PLANA (COMPONENTES ELEMENTALES)                                                zst_employees_joh(ANTES DE COLOCAR UN CAMPO STRUC.
    "ESTRUCTURA ANINDADA (UN COMPONENTE ES UNA STRUC.)                                         zst_employees_joh
    "ESTRUCTURA INCLUDE (SOLO INCLUYE LOS COMPONENTES DE OTRA STRC. CON "INCLUDE" (ES PLANA)   zst_employees_incl_joh

    DATA ls_employee TYPE zst_employees_joh.

    ls_employee-employee_id = '001'.
    ls_employee-category = '01'.
    ls_employee-address-address_id = '0005'. "ESTO LA HACE UNA NEST STRUC.


*    """"""INCLUDE (ES UNA FLAT)
    DATA ls_g_employee_incl TYPE zst_employees_incl_joh.

    ls_g_employee_incl-address_id = '00001'.
    ls_g_employee_incl-city = 'Aragua'.

    out->write( |ESTRUC. INCL. ADDRESS ID: { ls_g_employee_incl-address_id }| ).


*    """"""ESTRUC LOCAL FLAT EL ABAP CON INCLUDE
    TYPES: BEGIN OF ty_employee,
             employee_id TYPE c LENGTH 10,
             first_name  TYPE zde_first_name_joh,
             last_name   TYPE zde_last_name_joh,
             start_date  TYPE zde_start_date_joh,
             category    TYPE zde_job_category_joh,
             include     TYPE   zst_empl_address_joh.   "TIPO STRUC.
    TYPES: END OF ty_employee.

*    """"""ESTRUC LOCAL NESTED EL ABAP
    TYPES: BEGIN OF ty_employee_NESTED,
             employee_id TYPE c LENGTH 10,
             first_name  TYPE zde_first_name_joh,
             last_name   TYPE zde_last_name_joh,
             start_date  TYPE zde_start_date_joh,
             category    TYPE zde_job_category_joh,
             address     TYPE   zst_empl_address_joh,    "TIPO STRUC .
           END OF ty_employee_NESTED.


*   """"""ITAB A PARTIR DE UN TIPO TABLA EN EL DICCIONARIO
    DATA: lt_empl_address_joh TYPE ztt_empl_address_joh,  "TABLA INTERNA (DE UN TIPO TABLA DEL DIC. DATOS SIN COLOCAR STANDAR TABLE OF)
          ls_empl_address_joh TYPE zst_empl_address_joh.  "TIPO STRUC.

    ls_empl_address_joh-address_id = '0001'.
    APPEND ls_empl_address_joh TO  lt_empl_address_joh.


*    """"""ESTRUC. PROFUNDA (UN CAMPO DE LA STRC. ES UNA TABLA)

    DATA ls_employees_deep TYPE zst_employee_joh.
    ls_employees_deep-address[ 1 ]-apartment = '0001'. "ES POSIBLE ACCEDER A LOS COMPÒNENTES DE LA ITAB CON INDICE QUE ESTA CONTENIDA EN LA STRUC.



*   """"""CLAVE SECUNDARIA (SKEY) PARA BUSQUEDAS

    "TIPO TABLA EN CODIGO ABAP (PARA ALTO VOLUMEN DE DATOS)
    TYPES: tt_employe_s TYPE SORTED TABLE OF ty_employee_SKEY
                          WITH UNIQUE KEY employee_id                                "CLAVE PRIMARIA UNICA
                          WITH NON-UNIQUE SORTED KEY cat_status COMPONENTS category  "CLAVE SEC. CON NOMBRE (CAT_STATUS) Y SUS COMPONENTES
                                                                           status.
    "WITH FURTHER SECONDARY KEYS INITIAL SIZE 50.              "ESTO ES BLOQUE INICIAL EN MEMORIA ES OPCIONAL


    DATA gt_employees_skey TYPE tt_employe_s.  "DECLARA UN ITAB CON LAS CARECT DE LA DE ARRIBA

    "ITERACIONES
    LOOP AT gt_employees_skey ASSIGNING FIELD-SYMBOL(<fs_gt_employees>)  "USANDO UNA ITERACION CON UNA CONDICION POR PKEY
            WHERE employee_id BETWEEN '0000000001' AND '0000000100'.
    ENDLOOP.


    LOOP AT gt_employees_skey ASSIGNING FIELD-SYMBOL(<fs_gt_employees_2>)  "USANDO UNA ITERACION CON UNA CONDICION POR SKEY
        USING KEY cat_status                "USANDO EL NOMBRE DE LA SKEY
        WHERE category = '02'               "Y CONDICIONES POR LA SKEY
        AND status = 'A'.
    ENDLOOP.


    "LECTURA CON SKEY (READ TABLE)
    TRY.
        DATA(gs_employees_skey) = gt_employees_skey[ KEY cat_status COMPONENTS category = '02'
                                                                               status   = 'A' ].
      CATCH cx_sy_itab_line_not_found INTO DATA(lx_itab_not_found).

    ENDTRY.


*   """"""TIPO TABLA ANIDADA

    DATA lt_nested_employees TYPE ztt_employees_nested_joh.

    LOOP AT lt_nested_employees ASSIGNING FIELD-SYMBOL(<fs_nested_employees>).
      DATA(ls_first_address) = VALUE #( <fs_nested_employees>-address[ 1 ] OPTIONAL ).  "EN EL COMPONENTE ADRESS HAY OTRA ITABLE

      LOOP AT <fs_nested_employees>-address ASSIGNING FIELD-SYMBOL(<fs_address>).       "SE HACE UN BUCLE SOBRE EL PUNTERO QUE APUNTA AL CAMPO TABLA DENTRO DE LA ITABLA.
        <fs_address>-apartment = ''.   "ESTO ES UN COMPONENTE DEL CAMPO TABLA QUE PERTENECE A LA PRIMERA TABLA
      ENDLOOP.
    ENDLOOP.




  ENDMETHOD.
ENDCLASS.
