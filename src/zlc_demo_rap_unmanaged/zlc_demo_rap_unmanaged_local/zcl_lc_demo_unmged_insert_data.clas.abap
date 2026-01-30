CLASS zcl_lc_demo_unmged_insert_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
protected section.
private section.
ENDCLASS.



CLASS ZCL_LC_DEMO_UNMGED_INSERT_DATA IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(lo_rap) = zcl_lc_demo_rap_data_handler=>create_instance( ).

    lo_rap->modify( VALUE #( text = 'Belgium' ) ).
    lo_rap->modify( VALUE #( text = 'Germany' ) ).
    lo_rap->modify( VALUE #( text = 'USA' ) ).

    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
