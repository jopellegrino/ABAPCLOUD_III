CLASS zcl_13_texto_03 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_13_TEXTO_03 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

   CONSTANTS gc_initial(10) TYPE c VALUE '    ABC123'.
    DATA(gv_final_str) = gc_initial.


    """"""""""OPERADOR SHIFT""""""""""

    out->write( |Inicial:                                  /{ gv_final_str }| ).

    SHIFT gv_final_str.                                             "ELIMINA UN ESPACIO A LA IZQ.
    out->write( |Operador Shift Elim. (1) Izq:             /{ gv_final_str }| ).

    gv_final_str = gc_initial.
    SHIFT gv_final_str BY 8 PLACES.                                 "ELIMINA 8 ESPACIOS A LA IZQ.
    out->write( |Operador Shift (8) places de la Izq:      /{ gv_final_str }| ).

    gv_final_str = gc_initial.
    SHIFT gv_final_str BY 3 PLACES RIGHT.                           "ELIMINA 3 ESPACIOS A LA DER.
    out->write( |Operador Shift (3) places Der.:           /{ gv_final_str }| ).

    gv_final_str = gc_initial.
    SHIFT gv_final_str RIGHT DELETING TRAILING '123'.                "ELIMINA UN PATRON DE LA DER.
    out->write( |Operador Shift Del. Patron de la Der.:    /{ gv_final_str }| ).

    gv_final_str = gc_initial.
    SHIFT gv_final_str LEFT DELETING LEADING space.                   "SPACE ES PALABRA RESERVADA (BORA LOS ESP. DE LA IZQ.
    out->write( |Operador Shift Del. todos los Esp. Izq.:  /{ gv_final_str }| ).

    out->write( |  | ).

    """"""""""FUNCION SHIFT"""""""""" REDUCEN LA LONG. DE LA CADENA
    gv_final_str = gc_initial.
    gv_final_str = shift_left( val = gv_final_str places = 2 ).       "ELIMINA LOS PLACES(2) DE LA IZQ.
    out->write( |Funcion Shift Borra 2 Places de la Izq.:  /{ gv_final_str }| ).

    gv_final_str = gc_initial.
    gv_final_str = SHIFT_right( val = gv_final_str places = 2 ).      "ELIMINA LOS PLACES(2) DE LA DER.
    out->write( |Funcion Shift Borra 2 Places de la Der.:  /{ gv_final_str }| ).

    gv_final_str = gc_initial.
    gv_final_str = SHIFT_left( val = gv_final_str circular = 5 ).    "MUEVE EL STRING COMO UN CIRCULO HACIA LA IZQ.
    out->write( |Funcion Shift Circular (5) hacia la Izq.: /{ gv_final_str }| ).

    gv_final_str = gc_initial.
    gv_final_str = shift_right( val = gv_final_str sub = '123' ).    "ELIMINA LOS PLACES DE UN SUB STRING
    out->write( |Funcion Shift sub Elim. un Sub a la Izq.:/{ gv_final_str }| ).

    gv_final_str = gc_initial.
    gv_final_str = shift_left( val = gv_final_str ).                 "ELIMINA LOS PLACES QUE TIENEN UN ESPACIO
    out->write( |Funcion Shift sin patron Elim. los Esp. a la Izq.:/{ gv_final_str }| ).

    out->write( |  | ).


    """"""""""STRLEN FUNTION""""""""""

    DATA: lv_leght   TYPE c LENGTH 6,
          lv_string  TYPE string VALUE 'Logali Group   ',  "COMILLA SIMPLE
          lv_string2 TYPE string VALUE `Logali Group   `. "COMILLA HACIA DER.


    lv_leght = strlen( lv_string ).
    out->write( |Funcion Strlen de '': { lv_string }es de:{ lv_leght } | ). "LONGITUD '' DEL STRING ES SIN CONTAR LOS ESPACIOS EN BLANCO FINALES

    lv_leght = strlen( lv_string2 ).
    out->write( |Funcion StrLen de ``: { lv_string2 }es de:{ lv_leght } | ). "LONGITUD `` CUENTA LOS ESPACIOS EN BLANCO

    """"""""""NUM OF CHAR""""""""""

    lv_leght = numofchar( lv_string ).
    out->write( |Funcion NumOfChar con '' :{ lv_leght } | ).      "EN AMBOS CASOS IGNORA LOS ESPACIOS EN BLANCO

    lv_leght = numofchar( lv_string2 ).
    out->write( |Funcion NumOfChar con `` :{ lv_leght } | ).
    out->write( |  | ).

    """""""""TO_LOWER / TO_UPPER""""""""""

    DATA(LV_String3) = 'abcdexyec'.
    DATA(LV_String4) = 'INVaXXYYZz'.

    out->write( |Taxto Original (1): { LV_String3 }  | ).
    DATA(lv_invoice) = to_upper( LV_String3 ).
    out->write( |Funcion TO_UPPER: { lv_invoice }| ).

    out->write( |Taxto Original (2): { LV_String4 }  | ).
    lv_invoice = to_lower( LV_String4 ).
    out->write( |Funcion TO_LOWER: { lv_invoice }| ).

    out->write( |  | ).


    """"""""""TRASLATE""""""""""

    lv_invoice = '123clientinv02'.
    out->write( |Texto Original: { lv_invoice } | ).

    TRANSLATE lv_invoice TO UPPER CASE.
    out->write( |Translate To Upper Case: { lv_invoice } | ).

    TRANSLATE lv_invoice TO LOWER CASE.
    out->write( |Translate To Lower Case: { lv_invoice } | ).


    """"""""""INSERT/REVERSE""""""""""


    DATA(lv_ins_string) = '123CLIENT02'.
    out->write( |Texto Original: { lv_ins_string }  | ).

    lv_ins_string = insert( val = lV_INS_STRING sub = 'inv' off = 3 ).  "INSERTA UN SUB EN UN STRING EN LA POSIC. (3)
    out->write( |Texto con metodo Insert: { lv_ins_string }  | ).       "SI NO COLOCAS OFF SE INSERTA EN POSIC. (0)

    lv_ins_string = reverse( lv_ins_string ).
    out->write( |Texto con metodo reverse: { lv_ins_string }  | ).       "CAMBIA EL ORDEN DEL STRING

  ENDMETHOD.
ENDCLASS.
