CLASS zcl_lc_demo_interface_clean DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    TYPES tt_travel TYPE STANDARD TABLE OF /dmo/travel WITH EMPTY KEY.

    METHODS main IMPORTING io_interface TYPE REF TO zcl_lc_demo_method_interface
                 RETURNING VALUE(rv_result) TYPE abap_boolean.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS select_data
      IMPORTING io_interface     TYPE REF TO zcl_lc_demo_method_interface
      RETURNING VALUE(rt_travel) TYPE tt_travel.

    METHODS update_data
      IMPORTING it_travel    TYPE tt_travel
                io_interface TYPE REF TO zcl_lc_demo_method_interface
      RETURNING VALUE(rv_result) TYPE abap_boolean.
ENDCLASS.



CLASS zcl_lc_demo_interface_clean IMPLEMENTATION.
  METHOD main.
    " Select Travels
    DATA(lt_travel) = select_data( io_interface ).

    " Update Travels and confirm further
    RETURN
    update_data( it_travel    = lt_travel
                 io_interface = io_interface ).
  ENDMETHOD.

  METHOD select_data.
    SELECT FROM /dmo/travel
      FIELDS *
      WHERE agency_id   IN @io_interface->mt_r_agency_id
        AND customer_id IN @io_interface->mt_r_customer_id
      INTO TABLE @rt_travel.
  ENDMETHOD.

  METHOD update_data.
    " Travels
    DATA(lt_travel) = it_travel.

    " Change description
    LOOP AT lt_travel REFERENCE INTO DATA(lr_travel).
      lr_travel->description = io_interface->cs_lc_test.
    ENDLOOP.

    " Update Travel
    IF io_interface->cs_test IS NOT INITIAL.
      UPDATE /dmo/travel FROM TABLE @lt_travel.
    ENDIF.

    " Is this true?
    RETURN xsdbool( sy-subrc IS INITIAL ).
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    " Method interface
    DATA(lr_interface) = NEW zcl_lc_demo_method_interface( ).

    " Filter
    lr_interface->mt_r_customer_id = VALUE #( ( sign = 'I' option = 'EQ' low = '000264' ) ).
    lr_interface->mt_r_agency_id   = VALUE #( ( sign = 'I' option = 'EQ' low = '070051' ) ).

    " Execute main
    DATA(lv_result) = main( lr_interface ).

    " Output
    out->write( |Updated successfully: { lv_result }| ).
  ENDMETHOD.

ENDCLASS.
