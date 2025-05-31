CLASS zcl_24_itab2_agrup_de_regis DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_24_ITAB2_AGRUP_DE_REGIS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  """"""""""GROUP BY (AGRUPACION DE REGISTROS DE UNA ITAB)(VARIANTE DE LOOP AT YA QUE SE ITERA)

    SELECT FROM /dmo/flight
    FIELDS *
    INTO TABLE @DATA(gt_dmo_flight).

    "VARIABLE PARA ALOJAR LOS GRUPOS E IMPRIMIR GRUPOS

*    """""""""""AGRUPADO POR COLUMNAS (ESPECIFICA)(SOLO MUESTRA LAS CLAVES DE GRUPOS CUANDO COLOCAS UN SOLO LOOP, PARA MOSTRA TODO EL GRUPO NECESITAS UNA VARIABLE EXTRA Y OTRO LOOP)

    LOOP AT gt_dmo_flight ASSIGNING FIELD-SYMBOL(<lfs_dmo_flight>)      "USAMOS UN APUNTADOR PARA RECORRER LA TABLA, PERO SE PUEDE USAR UNA WORKAREAS

    GROUP BY <lfs_dmo_flight>-carrier_id.                               "APUNTAMOS AL CAMPO POR EL QUE QUIERES AGRUPAR LOS REGISTROS, "TODOS CAMPOS SE LES ASGINA UN GRUPO EN EL QUE SON IGUALES
      out->write( data = <lfs_dmo_flight> name = 'SOLO CLAVES DE GRUPO' ).  "SE LEEN TODAS LAS FILAS Y SE CREA UNA CLAVE DE GRUPO A PARTIR DEL CAMPO POR EL QUE QUIERES AGRUPAR

    ENDLOOP.                                                            "EL ORDEN ES POR EL PRIMERO QUE SE ENCUENTRE DE CLAVE DE GRUPO,"NOTA: CADA EXTRUCTURA (APUNTADOR) TIENE LA PRIMERA LINEA DE CADA GRUPO CREADO
    out->write( | | ).



*    """""""""""""AGRUPADO POR COLUMNAS E IMPRIME LOS GRUPOS ENTEROS

    DATA gt_member LIKE gt_dmo_flight.


    LOOP AT gt_dmo_flight ASSIGNING FIELD-SYMBOL(<lfs_dmo_flight2>)

    GROUP BY <lfs_dmo_flight2>-carrier_id.                    "HACE UN LOOP EN LA TABLA Y BUSCAR TODOS LOS CAMPOS IGUALE Y LES ASIGNA UN GRUPO CON SU LLAVE DE GRUPO, QUE ES EL PRIMER CAMPO ENCONTRADO

      CLEAR gt_member.                                        "ESTO GUARDA CADA GRUPO ENTERO, Y POR ELLO SE LIMPIA PARA VOLVERSE A RELLENAR EN EL LOOP


      LOOP AT GROUP <lfs_dmo_flight2> INTO DATA(gs_member).   "LUEGO HAGO UN LOOP RECORRIENDO CADA GRUPO, Y GUARDANDO SIEMPRE LA ITERACION ANTERIOR EN GT_MEMBER
        gt_member = VALUE #( BASE gt_member ( gs_member ) ).  "AQUI GUARDA EL GRUPO FUCIONADO Y LUEGO SE LE SUMA EL SEGUNDO GRUPO HASTA LLENAR EL GRUPO, MANTENIENDO COMO BASE EL GRUPO ENTERO EN CADA ITERACION
      ENDLOOP.

      out->write( data = gt_member name = 'GT_MEMBERS (TODO EL GRUPO, UN CAMPO)' ).     "IMPRIME EL GRUPO ENTERO

    ENDLOOP.
    out->write( | | ).



*   """""""""""AGRUPAR POR VARIOS COLUMNAS Y ASIGNAR CLAVE DE GRUPO

    LOOP AT gt_dmo_flight ASSIGNING FIELD-SYMBOL(<lfs_dmo_flight3>)

    GROUP BY ( airline = <lfs_dmo_flight3>-carrier_id                                   "ESTO TOMA EN CUENTA PARA AGRUPAR POR DOS COLUMNAS (CAMPOS)
               plane = <lfs_dmo_flight3>-plane_type_id ) INTO DATA(gs_key).             "AGRUPAR POR CLAVE(GROUP KEY BIDING) (ASIGNAR A LA AGRUPACION UNA CLAVE, Y REUNE TODOS LOS CRITERIOS DE AGRUPACION Y PODER USARLA)

      CLEAR gt_member.


      LOOP AT GROUP gs_key INTO gs_member.
        gt_member = VALUE #( BASE gt_member ( gs_member ) ).
      ENDLOOP.

      out->write( data = gt_member name = 'GT_MEMBERS (AGRUPADO POR DOS CAMPOS)' ).
      out->write( data = gs_key name = 'gs_key' ).                                        "ESTO IDENTIFICA O IMPRIME EL GRUPO POR EL CUAL SE ESTA AGRUPANDO

    ENDLOOP.
    out->write( | | ).



*   """"""""""WITHOUT MEMBERS (YA NO MUESTRA LOS MIEMBROS DE CADA GRUPO)

    LOOP AT gt_dmo_flight ASSIGNING FIELD-SYMBOL(<lfs_dmo_flight4>)

    GROUP BY ( airline = <lfs_dmo_flight4>-carrier_id
               plane = <lfs_dmo_flight4>-plane_type_id
               index = GROUP INDEX                                                "ESTOS COMPONENTES DAN CUANTAS CLAVES DE GRUPOS Y MIEMBROS HAY POR AGRUPACION
               size = GROUP SIZE          ) WITHOUT MEMBERS INTO DATA(gs_key2).   "ESTO MUESTRA OTROS COMPONENTES Y NO LOS MIEMBROS TOTALES


      out->write( data = gs_key2 name = 'gs_key2' ).

    ENDLOOP.
    out->write( | | ).
    out->write( | | ).




*    """""""""FOR GROUPS (AGRUPA LAS FILAS QUE CUMPLAN LA CONDICION POR LA CLAVE ESPECIFICADA (DE GRUPO)

    SELECT FROM /dmo/flight
    FIELDS *
    INTO TABLE @DATA(gt_dmo_flight_02). "ES POSIBLE HACERLA DENTRO DE UNA IMPRESION O COLOCARLA EN UNA VARIABLE

    TYPES lty_groups_keys TYPE STANDARD TABLE OF /dmo/flight-carrier_id WITH EMPTY KEY.     "UNA TABLA INTERNA CON SOLO UN CAMPO

    out->write( VALUE lty_groups_keys( FOR GROUPS gv_group OF gs_group IN gt_dmo_flight_02      "GV ES ITERACION EN GRUPOS, GS ESTRUC UTILIZADA PARA ITERAR (AMBOS DECLARACIONES EN LINEA), IN ITAB
                                           GROUP BY gs_group-carrier_id                          "CAMPO/CLAVE PARA AGRUPAR O VARIOS CAMPOS
                                           DESCENDING
                                           WITHOUT MEMBERS ( gv_group ) "QUE NO SE MUESTRE LOS MIEMBROS Y SOLO SE MUESTRA LA CLAVE DE AGRUPACION, LO QUE ESTA EN PARENTESIS, OSEA EL NOMBRE DE LA AGRUPACION
                                                                                    ) ).





  ENDMETHOD.
ENDCLASS.
