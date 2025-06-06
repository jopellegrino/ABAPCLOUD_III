CLASS zcl_01_exp_constr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


*   """""NEW"""""(1 DE 3) (REFERENCIAS A CLASES)

    DATA: lv_name TYPE string,
          lv_age  TYPE i.

    METHODS: constructor IMPORTING iv_name TYPE string  "PARAMETROS DE IMPORTACION, LOS VALORES QUE TRAE DE DONDE SE UTILICE ESTA CLASE Y SE HAGA ACCESO AL ESTE METODO
                                   iv_age  TYPE i.


    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_01_EXP_CONSTR IMPLEMENTATION.


  METHOD constructor. "(2 DE 3) IMPLEMENTACION DEL METODO CONSTRUCTOR CREADO, QUE SIMPLEMENTE RECIBE LOS DATOS IV Y SE LOS ASIGNA A LA VARIABLES Y LUEGO IMPRIMO ESAS VARIABLES

    lv_age = iv_age.
    lv_name = iv_name.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

*  """""""""""VALUE (INICIALIZACION DE ESTRUC., TABLAS O VAR. CON VALORES ESPECIFICOS)

    DATA(lt_msg) = VALUE string_table( ( `Welcome` )  ( `Student` )   ).          "TABLA DE TIPO ELEMENTAL `STRING` (OSEA DE STRINGS SIN COMPONENTES)
    out->write( data = lt_msg Name = 'LT_MSG' ).
    out->write( | | ).

    lt_msg = VALUE #(  ).                                                          "ESTO INICIALIZA TODO EL CONTENIDO (OSEA BORRA TODO EL CONTENIDO)
    out->write( data = lt_msg Name = 'LT_MSG' ).
    out->write( | | ).

    """"""CON STRUC. ANIDADA (COLOCA VALUE ANIDADO)

    DATA: BEGIN OF ls_emp_data,
            emp_name TYPE /dmo/first_name,

            BEGIN OF adress,
              street TYPE /dmo/street,
              number TYPE i,
            END OF adress,

          END OF ls_emp_data.

    ls_emp_data = VALUE #( emp_name = 'Laura'
                           adress = VALUE #( street = 'Street CA' number = 22 )  ).

    out->write( data = ls_emp_data Name = 'LS_EMP_DATA' ).
    out->write( | | ).


*   """"""""""CORRESPONDING (TRANSFERIR VALORES ENTRE STRUCS. O ITABS BASANDO EN LA CORRESPONDENCIA DE LOS NOMBRES DE LOS CAMPOS)

    TYPES: BEGIN OF lty_employee,           "PARTICULARIDADLOS NOMBRES DE LOS CAMPOS NO SON IGUALES, DE DEBE COLOCAR MAPEO YA QUE SI NO SE HACE EL CONTENIDO SE PASA VACIO
             emp_name TYPE string,
             emp_age  TYPE i,
           END OF lty_employee.

    TYPES: BEGIN OF lty_person,
             name TYPE string,
             age  TYPE i,
           END OF lty_person.

    DATA: lt_employee TYPE STANDARD TABLE OF lty_employee,   "TABLA 1(PROCEDENCIA DE DATOS)
          lt_person   TYPE STANDARD TABLE OF lty_person,     "TABLA 2(RECEPTOR DE DATOS)
          lt_client   TYPE STANDARD TABLE OF lty_person.

    lt_employee = VALUE #( ( emp_name = 'Jhon King'    "SE PODRIA COLOCAR UN FOR PARA ITERAR MILES DE REGISTROS EN VEZ DE UNO, DE UNA A OTRA TABLA
                             emp_age = 30  ) ).
    out->write( data = lt_employee name = 'LT_EMPLOYEE' ).
    out->write( | | ).

    out->write( | """""CORRESPONDING MAPPING""""" | ).

    lt_person = CORRESPONDING #( lt_employee MAPPING name = emp_name age = emp_age ). "EL MAPEO AYUDA A GUIAR DONDE CORRESPONDEN LOS DATOS
    out->write( data = lt_person name = 'LT_PERSON' ).
    out->write( | | ).


*    """""CORRESPONDING BASE (UNA ITAB CON SUS CAMPOS COMO BASE DE OTRA QUE YA TENIA CAMPOS Y SE MANTIENEN Y SE AGREGAN MAS)

    out->write( | """""CORRESPONDING BASE""""" | ).

    lt_client = VALUE #( ( name = 'Maria Lopez'
                           age = 52                ) ).

    lt_client = CORRESPONDING #( BASE ( lt_client ) lt_person ). "SE COLOCA COMO BASE A ELLA MISMA, Y LUEGO SE AGREGAN LOS CAMPOS DE OTRA TABLA
    out->write( data = lt_client name = 'LT_CLIENT' ).
    out->write( | | ).


*    """"""""""CORRESPONDING "EXCEPT(1)"

    out->write( | """""CORRESPONDING EXCEPT""""" | ).

    lt_person = CORRESPONDING #( lt_client EXCEPT age ). "(1)EXCLUIR CIERTOS CAMPOS (AGE) DEL PROCESO DE COPIA DE ITAB A OTRA, LOS DEJA EN CERO
    out->write( data = lt_person name = 'LT_PERSON' ).
    out->write( | | ).


*   """""DISCARDING DUPLICATES (2) (SE PASAN LOS CAMPOS DE UNA TABLA SIN KEY, A OTRA CON KEY UNICA, QUE NO PUEDE TENER DUPLICADOS, ASI QUE SE DEBE ELIMINAR LOS DUPLICADOS

    out->write( | """""CORRESPONDING DISCARDING DUPLICATES""""" | ).

    DATA: lt_itab_stand TYPE STANDARD TABLE OF lty_person WITH EMPTY KEY,        "NO TIENE KEY, POR ENDE TODOS LOS CAMPOS PUEDE TENER DUPLICADOS
          lt_itab_SORT  TYPE SORTED TABLE OF lty_person WITH UNIQUE KEY name.    "TIENE KEY UNICA (NAME) POR ENDE NO DEBE TENER DUPLICADOS

    lt_itab_stand = VALUE #( ( name = 'Maria' age = 22 )                         "TIENE 3 REGISTROS CON NAME IGUALES, NO PUEDE PASARSE A UNA SORT ASI, SIN ELIMINAR LOS DUPLICADOS
                        ( name = 'Maria' age = 25 )                              "DARIA ERROR (ITAB_DUPLICATE_KEY)
                        ( name = 'Maria' age = 22 )
                        ( name = 'Carmen' age = 45 )  ).


    lt_itab_SORT = CORRESPONDING #( lt_itab_stand DISCARDING DUPLICATES ).       "ESTO ELIMINA LOS DUPLICADOS POR ENDE SE PIEDEN REGISTROS
    out->write( data = lt_itab_SORT name = 'LT_ITAB_SORT' ).
    out->write( | | ).


*   """"""""""NEW (SE UTILIZA PARA CREAR INSTANCIAS DE CLASE MODERNA)(SE OBTIENE UNA VAR. DE REF. QUE APUNTA AL NEW OBJETO CREADO)(MAYORMENTE EN CLASES)

    out->write( | """""NEW""""" | ).

    "AUTOREFERENCIA (A UN TIPO PRIMITIVO I)
    DATA lo_data TYPE REF TO i.     "CREACION DE VAR. DE REF. DE DATOS (LO = LOCAL OBJECT)

    lo_data = NEW #( 1234 ).        "->* SELECTOR DE COMPONENTES DE OBJETO, APUNTA AUN ATRIBUTO DE UNA CLASE, INTROD. UN METODO INDEPENDIENTE O FUNCIONAL
    out->write( lo_data ).

    "REFERENCIA EXPLICITA (DECL. EN LINEA)(A UN TIPO PRIMITIVO STRING)
    DATA(lo_data_02) = NEW string( 'Logali' ).
    out->write( lo_data_02 ).

    out->write( | | ).

*   """""NEW USANDO CLASE"""" VER EN PUBLIC SECTION - Y ARRIBA DEL METODO Y PÒR ULTIMO SU USO O LLAMADO EN LA CLASE zcl_26_itab_pdf



*   """""CONV""""" (PARA REALIZAR CONVERSIONES EXPLICITAS DE DATOS, CONVERTIR DE UN TIPO DE DATO A OTRO)

    out->write( | """""OPERADOR CONSTRUCTOR CONV""""" | ).

    DATA: lv_int    TYPE i VALUE 123,
          lv_string TYPE string.

    lv_string = CONV string( lv_int ). "SE CONVIERTE UN INT A STRING, PARA ASIGNALO A UNA VAR TIPO STRING
    out->write( lv_string ).






  ENDMETHOD.
ENDCLASS.
