CLASS zlc_lc_demo_set_initial_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    METHODS: create_numberrange_intervals
      IMPORTING
        iv_object TYPE cl_numberrange_intervals=>nr_object.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zlc_lc_demo_set_initial_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " Partner - Set Initial Data (ZLC_DEMO_RAP_SIMPLE)
    DATA lt_partner TYPE STANDARD TABLE OF zlc_dmo_partner.

    lt_partner = VALUE #( ( partner = '1000000000'
                            name = 'SAP'
                            street = 'Test Street 1'
                            City = 'Berlin'
                            country = 'DE'
                            payment_currency = 'EUR' )
                          ( partner = '1000000001'
                            name = 'Microsoft'
                            street = 'Test Street 1'
                            City = 'New York'
                            country = 'US'
                            payment_currency = 'USD' )
                          ( partner = '1000000002'
                            name = 'Meta'
                            street = 'Test Street 1'
                            City = 'Los Angeles'
                            country = 'US'
                            payment_currency = 'USD' )
                          ( partner = '1000000003'
                            name = 'X Corp'
                            street = 'Test Street 1'
                            City = 'San Francisco'
                            country = 'US'
                            payment_currency = 'USD' )
                        ).

    DELETE FROM zlc_dmo_partner.

    INSERT zlc_dmo_partner FROM TABLE @lt_partner.

  ENDMETHOD.

  METHOD create_numberrange_intervals.

*    DATA: lv_object TYPE cl_numberrange_intervals=>nr_object VALUE 'ZLCCONTACT'.
*
*    TRY.
*        cl_numberrange_intervals=>create(
*      EXPORTING
*        interval = VALUE #( ( nrrangenr = '01' fromnumber = '100000000' tonumber = '199999999' )
*                            ( nrrangenr = '05' fromnumber = '500000000' tonumber = '599999999' )
*                            ( nrrangenr = '09' fromnumber = '900000000' tonumber = '999999999' ) )
*        object   = iv_object
*      IMPORTING
*        error    = DATA(ld_error)
*    ).
*      CATCH cx_number_ranges.
*        "handle exception
*    ENDTRY.

  ENDMETHOD.

ENDCLASS.
