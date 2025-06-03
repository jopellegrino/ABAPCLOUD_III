CLASS zcl_insert_univ_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_insert_univ_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    INSERT zuniversity_joh FROM TABLE @( VALUE #( ( client = '001'
                                                    soc    = '1000'
                                                    exercise = '2024' )

                                                    ( client = '002'
                                                    soc    = '2000'
                                                    exercise = '2022' )

                                                    ( client = '003'
                                                    soc    = '3000'
                                                    exercise = '2025' )    ) ).

    IF sy-subrc = 0.
      out->write( |Se han insertado { sy-dbcnt } registros| ).
    ELSE.
      out->write( |Ha fallado el insert| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
