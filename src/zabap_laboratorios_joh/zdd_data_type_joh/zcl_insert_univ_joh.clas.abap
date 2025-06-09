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

    DELETE FROM zuniversity_joh.

    INSERT zuniversity_joh FROM TABLE @( VALUE #( ( client = '001'
                                                    soc    = '1000'
                                                    exercise = '2024'
                                                    First_name = 'Pedro'
                                                    last_name = 'Perez '  )

                                                  ( client = '002'
                                                    soc    = '2000'
                                                    exercise = '2022'
                                                    First_name = 'Jose'
                                                    last_name = 'Jimenez ' )

                                                  ( client = '003'
                                                    soc    = '3000'
                                                    exercise = '2025'
                                                    First_name = 'Angelo'
                                                    last_name = 'Aguilar ' )

                                                  ( client = '004'
                                                    soc    = '4000'
                                                    exercise = '2020'
                                                    First_name = 'Maria'
                                                    last_name = 'Nuñez ' )

                                                    ( client = '005'
                                                      soc    = '7000'
                                                      exercise = '2023'
                                                      First_name = 'Samira'
                                                      last_name = 'Tovar '      ) ) ).

    IF sy-subrc = 0.
      out->write( |Se han insertado { sy-dbcnt } registros| ).
    ELSE.
      out->write( |Ha fallado el insert| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
