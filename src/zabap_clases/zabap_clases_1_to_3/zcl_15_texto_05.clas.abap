CLASS zcl_15_texto_05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_15_texto_05 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    """"""""""OPERADORES DE COMPARACION""""""""""
    DATA lv_match TYPE abap_bool.                                           "sy-fdpos = POS. 1ERA DEL PATRON SI NO HAY PATRON DA LA LONG. DE LA CADENA
    DATA(lv_text) = 'This is an example text for SAP_ABAP programming'.

    IF lv_text CP '*SAP#_*'.                                                "(CP)CONTIENE EL PATRON (* = CUALQUIER SECUENCIA DE CARACTERES)
      lv_match = abap_true.                                                 "# = OBLIGATORION QUE DEBE ESTAR LA LETRA QUE SIGUE EN EL PATRON (_)
      out->write( |The text contains the pattern "SAP_"| ).
    ELSE.
      lv_match = abap_FALSE.
      out->write( |The text does not contains the pattern SAP_| ).
    ENDIF.

    IF lv_text NP '*g+'.                                            "+ = SOLO UN CARACTER Y TOMA EN CUENTA ESPACIO
      out->write( |The text does not contains the pattern "g"| ).
    ELSE.
      out->write( |The text contains the pattern "g"| ).
    ENDIF.

    out->write( | | ).
    """"""""""PCRE Y REGEX""""""""""

    DATA(LV_pcre) = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'.
    DATA(lv_email) = 'alumno@logali.com'.

    FIND REGEX lv_pcre IN lv_email.

    IF sy-subrc EQ 0.                                                   "SI SUBRC = 0 ENTONCES LA OPER. SI HIZO CORRECTAMENTE (DIF. 0 ENTONCES NO SE REALIZO CORRECTAMENETE)
      out->write( 'El correo esta correcto verificado con Regex' ).
    ELSE.
      out->write( 'NO esta correcto el correo con Regex' ).
    ENDIF.

    FIND PCRE lv_pcre IN lv_email.

    IF sy-subrc EQ 0.
      out->write( 'El correo esta correcto verificado con PCRE' ).
    ELSE.
      out->write( 'NO esta correcto el correo con Regex' ).
    ENDIF.

    DATA(lv_text1) = '123A?0.,000Z4#-AA'.
    out->write( |Cadena Inicial: { lv_text1 }| ).

    REPLACE ALL OCCURRENCES OF PCRE '[^A-Za-z0-9]+' IN lv_text1 WITH | |. "REEMPLAZA TODOS LOS CARAC. SEAN SIMBOLOS Y DEJA LAS LETRAS Y NUM.

    out->write( |Cadena limpia:  { lv_text1 }| ).

    out->write( | | ).

    """"""""""EXPRESIONES REGULARES"""""""""""

    DATA(lv_text2) = `ABAPppp Xpp1 SAppP`. "EL PCRE = SIMBOLO p CUANDO ESTA REPETIDO ENTRE 2 Y 4 VECES
    DATA lv_text3 TYPE string.

    out->write( |Cadena Original 2: { lv_text2 }| ).

    lv_text2 = replace( val = lv_text2 pcre = `p{2,4}` with = `*` occ = 0 ). "REMPLAZA LO QUE CONCID. CON EL PCRE TODO POR UN * YA QUE OCC = 0 LO HACE CON TODOS SIN OCC SOLO LO HARIA CON EL PRIMERO
    out->write( |Cadena Limpia 2:   { lv_text2 }| ).                         "PCRE = LAS LETRAS P QUE SE REPITAN ENTRE 2 Y 4 VECES SEGUIDAS

    lv_text2 = `ABAPppp Xpp1 SAppP`.

    lv_text2 = replace( val = lv_text2 pcre = `[^SAP]` with = `*` occ = 0 ). "REEMPLAZAR TODOS LOS QUE NO CUMPLAN CON LO QUE ESTA ENTRE LOS [] INDIVIDUALMENTE POR *
    out->write( |Cadena Limpia 3:   { lv_text2 }| ).                         "PCRE = REEMPLAZAR TODO LO QUE NO SEA "S A y P"

    lv_text2 = `ABAPppp Xpp1 SAppP`.

    lv_text2 = replace( val = lv_text2 pcre = `\s` with = `//` ).            "REEMPLAZO EL PRIMER ESPACIO POR // YA QUE NO TENEMOS OCC SOLO TOMA LA 1ERA COINCIDENCIA.
    out->write( |Cadena Limpia 4:   { lv_text2 }| ).

    lv_text2 = `ABAPppp Xpp1 SAppP`.

    REPLACE ALL OCCURRENCES OF PCRE '\s' IN lv_text2 WITH '?'.               "REEMPLAZA TODOS LOS ESPACIOS POR ?
    out->write( |Cadena Limpia 4:   { lv_text2 }| ).

    out->write( | | ).

    """"""""""FUNCION REPEAT""""""""""

    lv_text3 = repeat( val = 'Logali' occ = 4 ).     "REPITE UN STRING Y OCC = A LA CANTIDAD DE REPETICIONES
    out->write( |Funcion Repeat x4:         { lv_text3 }| ).

    lv_text3 = |ABAP{ repeat( val = ` ` occ = 10 ) }ABAP|.     "SE PUEDE METER LA FUNC. DENTRO DE UN STRING
    out->write( |Funcion Repeat X10 SPACES: { lv_text3 }| ).

    TRY.
        lv_text3 = |ABAP{ repeat( val = ` ` occ = -10 ) }ABAP|.    "NO SE PUEDE COLOCAR OCC=NEGAT. Y AQUI SE CAPTURA EL ERROR Y SE COLOCA UN MSJ PARA EL USER
      CATCH cx_sy_strg_par_val.
        out->write( |Invalid Operation| ).
    ENDTRY.

    """"""""""ESCAPE""""""""""" PARA MANEJAR CARACTERES ESPECIALES DE TEXTO COMO COMILLAS SIMPLES O DOBLES

    """"CONVIERTE EN FORMATO URL

    out->write( | | ).

    DATA(lv_url) = escape( val = 'Logali ABAP Academy @300' format = cl_abap_format=>e_url_full ).
    out->write( |Formato a URL: { lv_url } | ).

    "JSON
    lv_url = escape( val = 'Logali ABAP \ Academy @300' format = cl_abap_format=>e_json_string ).
    out->write( |Formato a JSON: { lv_url } | ).

    "STRING TEMPLATES
    lv_url = escape( val = 'Logali ABAP Academy @300' format = cl_abap_format=>e_string_tpl ).
    out->write( |Formato a String templates: { lv_url } | ).



  ENDMETHOD.
ENDCLASS.
