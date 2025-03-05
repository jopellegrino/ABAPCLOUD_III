CLASS zcl_15_texto_04 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_15_texto_04 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    """""""""OVERLAY""""""""""
    out->write( |OVERLAY| ).

    DATA(LV_name) = 'Abap_Class                     '.                             "LA SUPERPOSICION NO LA HACE SOBRE LETRAS Y LA PRIMERA VARIABLE SE CONSERVA (DEBES COLOCAR ESPACIOS)
    DATA(lv_company) = '--------------->logali Group'.


    OVERLAY LV_name WITH lv_company.                                                "SUPERPOSICION DE DOS VARIABLES
    out->write( |Overlay Superpsocion de un String con otro : { LV_name } | ).

    DATA(lv_String) = 'a.b.c.a.b.c.A'.
    DATA(lv_string2) = 'z.x.y.Z.x.y.z'.

    out->write( |Texto Original:                              { lv_String } | ).
    OVERLAY lv_String WITH lv_string2 ONLY 'ab'.                                    "SUPERPOSICION DE SOLO UNAS LETRAS
    out->write( |Overlay solo a y b de un String con otro :   { lv_String } | ).

    out->write( |  | ).

    """"""""""SUBSTRING"""""""""""FUNCION
    out->write( |SUBSTRING| ).

    DATA lv_string_a TYPE string VALUE 'LOGALI GROUP'.
    out->write( |Texto Original :                           { lv_string_a } | ).

    lv_string_a = substring( val = lv_string_a off = 7 len = 4 ).           "OFF LA POSICION Y LEN EL TAMAÑO DEL SUBSTRING A ENCONTRAR EN EL STRING
    out->write( |SubString encontrado desde la posicion 7:  { lv_string_a } | ).

    lv_string_a = 'LOGALI GROUP'.
    lv_string_a = SUBSTRING_from( val = lv_string_a sub = 'GA' len = 6 ).   "SUB = ES LA POSIC. DESDE DONDE EMPIEZA A CONTAR Y LEN EL TOTAL A CONTAR DEL SUBSTRING A EXTRAER
    out->write( |SubStringfrom encontrado desde de 'GA':    { lv_string_a } | ).

    lv_string_a = 'LOGALI GROUP'.
    lv_string_a = SUBSTRING_after( val = lv_string_a sub = 'GA' ).           "SUB = ES LA POSIC. DESPUES DE DONDE EMPIEZA A CONTAR
    out->write( |SubStringAfter encontrado despues de 'GA': { lv_string_a } | ).

    lv_string_a = 'LOGALI GROUP'.
    lv_string_a = substring_before( val = lv_string_a sub = 'GA' ).          "SUB = ES EL PATRON ANTES DE DONDE EMPIEZA A CONTAR SIN INCLUIR EL PATRON
    out->write( |SubStringBefore encontrado antes de 'GA':  { lv_string_a } | ).

    lv_string_a = 'LOGALI GROUP'.
    lv_string_a = substring_TO( val = lv_string_a sub = 'GA' ).              "SUB = ES EL PATRON ANTES DE DONDE EMPIEZA A CONTAR INCLUYENDO EL PATRON
    out->write( |SubStringBefore encontrado antes de 'GA':  { lv_string_a } | ).

    out->write( |  | ).

    """"""""""FIND""""""""""FUNCION Y OPERADOR

    out->write( |FIND| ).

    lv_string_a = 'ABAP Student'.
    out->write( |Texto Original :                         { lv_string_a } | ).

    DATA(lv_pos) = find_any_of( val = lv_string_a sub = 'x523z4e' ).       "DEVUELVE LA POS. DE LA PRIMERA COINC. DE CUALQUIERA DEL SUB.
    out->write( |Posicion de coincidencia findAnyOf:      { lv_pos } | ).

    lv_pos = sy-fdpos + 1.                                                 "DEVUELVE DIF. VALORES DEPENDIENDO DE LA FUNCION USADA(EN ESTE CASO LA 1ERA POS. DE LA COINCIDENCIA)
    out->write( |Posicion de coincidencia sy-fdpos:       { lv_pos } | ).

    lv_pos = find_any_of( val = lv_string_a sub = 'x523z4X' ).
    out->write( |Posicion de coincidencia (2) sy-fdpos:   { lv_pos } | ).  "YA QUE NO HAY COICIDENCIA DEVUELVE UN NUMERO EXTRAÑO (-1).

    out->write( |  | ).

    """""""""""FIND REGEX"""""""""""

    DATA: lv_string_c TYPE string VALUE 'ERP ##1 a nivel mundial desde 1972',
          lv_regex    TYPE string VALUE '[0-9]'.

    DATA(lv_find) = find( val = lv_string_c regex = lv_regex ).           "DEVUELVE LA 1ERA POSIC. DEL 1ER PATRON (UN NUMERO EN REGEX).
    out->write( |Posicion de la coinc. con Regex y Find:      { lv_find } | ).

    FIND ALL OCCURRENCES OF '#' IN lv_string_c MATCH COUNT DATA(lv_count) IGNORING CASE. "DEVUELVE EL NUMERO DE OCURRENCIAS DE UN PATRON EN UN STRING (OPERADOR) ignorando el case
    out->write( |Operador Num. de ocurrencias de un patron:   { lv_count } | ).

    lv_count = count( val = lv_string_c sub = '#' ).                       "DEVUELVE EL NUMERO DE OCURRENCIAS DE UN PATRON EN UN STRING (FUNCION)
    out->write( |Funcion Num. de ocurrencias de un patron:    { lv_count } | ).

    out->write( |  | ).

    """"""""""REPLACE"""""""""""VARIABLE EN TIEMPO DE EJEC. SYSUBRC = 0 (QUIERE DECIR QUE LOS CARAC. SE REEMPLAZA. CORRECTAMENTE ) SI ES DIF A CERO NO SE HIZO CORRECTAMENTE
    out->write( |REPLACE| ).

    DATA(lv_replace) = 'Logali-Group-SAP-Academy'.
    DATA(lv_sign) = '-'.

    out->write( |Texto Original:                                { lv_replace } | ).

    REPLACE lv_sign WITH '/' INTO lv_replace.                                        "OPERADOR SOLO REEMPLAZA EL PRIMER SIMBOLO ENCONTRADO POR OTRO
    out->write( |Texto con un simbolo (Oper.) Replace:          { lv_replace } | ).

    lv_replace = 'Logali-Group-SAP-Academy'.

    REPLACE ALL OCCURRENCES OF lv_sign IN lv_replace WITH '*'.                       "OPERADOR REEMPLAZA TODOS LOS SIMBOLOS DESEADO POR OTRO
    out->write( |Texto con todos simbolos (Oper.) Replace:      { lv_replace } | ).

    lv_replace = 'Logali-Group-SAP-Academy'.

    lv_replace = replace( val = lv_replace sub = lv_sign with = '+' occ = 2 ).       "METODO (OCC = POSICION-PATRON QUE QUIERES REEMPLAZAR (=0 ES TODO EL STRING)
    out->write( |Texto con todos simbolos (Func.) Replace:      { lv_replace } | ).  "SUB = ES EL SUB STRING QUE SE QUIERE REEMPLAZAR Y WITH POR EL CUAL SE CAMBIA

    lv_replace = 'Logali-Group-SAP-Academy'.
    lv_replace = replace( val = lv_replace with = '#' off = 5 len = 3 ).              "OFF = DESDE QUE POS. SE QUIERE REEMPLAZAR Y LEN = QUE TANTOS CARAC. QUE QUIERES REEMP.
    out->write( |Texto con todos simbolos (Oper.) Replace (2):  { lv_replace } | ).   "REEMPLAZO DESDE EL 5 TOMANDO LOS TRES CARAC. (I-G)



  ENDMETHOD.
ENDCLASS.
