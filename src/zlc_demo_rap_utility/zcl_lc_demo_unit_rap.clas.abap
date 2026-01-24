""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " In the RAP environment, there are these two types of tests (business object and service).
" We create the test class as a global class.
" The corresponding additions (FOR TESTING, DURATION, RISK LEVEL) must also be specified.
" We link the test class to the Core Data Service via the ABAP Doc comment.
" To do this, we want to implement three tests:
"   - Creating a new entry and checking the generated key
"   - Filling an entry with an empty street
"   - Delete all entries with an empty street
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"! @testing BDEF:ZLC_R_PARTNER
CLASS zcl_lc_demo_unit_rap DEFINITION
  PUBLIC FINAL CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.

    " Test double (mock data)
    CLASS-DATA:
      go_environment TYPE REF TO if_cds_test_environment.

    CLASS-METHODS:
      class_setup RAISING cx_static_check,
      class_teardown.

    METHODS:
      create_new_entry    FOR TESTING,
      fill_empty_streets  FOR TESTING,
      clear_empty_streets FOR TESTING.

ENDCLASS.



CLASS zcl_lc_demo_unit_rap IMPLEMENTATION.

  METHOD class_setup.

    DATA:
      lt_partner TYPE STANDARD TABLE OF zlc_dmo_partner WITH EMPTY KEY.

    go_environment = cl_cds_test_environment=>create(
        i_for_entity = 'ZLC_R_PARTNER'
        i_dependency_list = VALUE #( ( name = 'ZLC_DMO_PARTNER' type = 'TABLE' ) )
    ).

    lt_partner = VALUE #(
      ( partner = '2000000001' name = 'Las Vegas Corp' country = 'US' payment_currency = 'USD' )
      ( partner = '2000000002' name = 'Gorillas' street = 'Main street 10' country = 'DE' payment_currency = 'EUR' )
      ( partner = '2000000003' name = 'Tomato Inc' street = 'EMPTY' country = 'AU' payment_currency = 'AUD' )
    ).

    go_environment->insert_test_data( lt_partner ).
    go_environment->enable_double_redirection( ).

  ENDMETHOD.

  METHOD class_teardown.
    go_environment->destroy( ).
  ENDMETHOD.

  METHOD create_new_entry.
**********************************************************************
* The test fills a table with new data and marks the errors as relevant, then we insert the new data records
* and commit the data to the database. Then we check the return for errors.
* Finally, we read from the database whether the new entry was actually created.
**********************************************************************

*    DATA:
*      lt_new_partner TYPE TABLE FOR CREATE zlc_r_partner.

    " Prepare entry
*    lt_new_partner = VALUE #(
*       ( %data-PartnerName = 'Do it Yourself'
*         %data-Street = 'Bangaloo Street'
*         %data-City = 'Royal City'
*         %data-Country = 'GB'
*         %data-PaymentCurrency = 'GBP'
*         %control-PartnerName = if_abap_behv=>mk-on
*         %control-Street = if_abap_behv=>mk-on
*         %control-City = if_abap_behv=>mk-on
*         %control-Country = if_abap_behv=>mk-on
*         %control-PaymentCurrency = if_abap_behv=>mk-on
*       )
*      ).

    " Create entry
    MODIFY ENTITIES OF zlc_r_partner
      ENTITY Partner CREATE FROM VALUE #(
        ( %cid = 'MyCID_1'
          %data-PartnerName = 'Do it Yourself'
          %data-Street = 'Bangaloo Street'
          %data-City = 'Royal City'
          %data-Country = 'GB'
          %data-PaymentCurrency = 'GBP'
          %control-PartnerName = if_abap_behv=>mk-on
          %control-Street = if_abap_behv=>mk-on
          %control-City = if_abap_behv=>mk-on
          %control-Country = if_abap_behv=>mk-on
          %control-PaymentCurrency = if_abap_behv=>mk-on ) )
      MAPPED DATA(ls_mapped).

    " Commit
    COMMIT ENTITIES
      RESPONSE OF zlc_r_partner
      REPORTED DATA(ls_commit_reported)
      FAILED DATA(ls_commit_failed).

    " Assert initial
    cl_abap_unit_assert=>assert_initial( ls_commit_reported-partner ).
    cl_abap_unit_assert=>assert_initial( ls_commit_failed-partner ).

    " Read the new entry
    SELECT SINGLE FROM zlc_dmo_partner
      FIELDS partner, name
      WHERE name = 'Do it Yourself'
      INTO @DATA(ls_partner_found).

    " Assert - return code
    cl_abap_unit_assert=>assert_subrc( ).

  ENDMETHOD.

  METHOD fill_empty_streets.
**********************************************************************
* In the first step we transfer a partner for whom we want to carry out the action, we confirm the action
* with a commit and then read the current status from the database.
* The street should now read "EMPTY" and the entry should be found by the database.
**********************************************************************

*    DATA:
*     lt_fill_streets TYPE TABLE FOR ACTION IMPORT zlc_r_partner~fillEmptyStreets.
*
*    " For which Partner
*    lt_fill_streets = VALUE #( ( %tky-%key-PartnerNumber = '1000000008' ) ).

    " Execute action
    MODIFY ENTITIES OF zlc_r_partner
      ENTITY Partner EXECUTE fillEmptyStreets
      FROM VALUE #( ( %tky-%key-PartnerNumber = '2000000001' ) )
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    " Commit
    COMMIT ENTITIES
      RESPONSE OF zlc_r_partner
      REPORTED DATA(ls_commit_reported)
      FAILED DATA(ls_commit_failed).

    " Read entry to validate
    SELECT SINGLE FROM zlc_dmo_partner
     FIELDS partner, Street
     WHERE partner = '2000000001'
     INTO @DATA(ls_partner_found).

    " Assert
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = ls_partner_found-street exp = 'EMPTY' ).

  ENDMETHOD.

  METHOD clear_empty_streets.
**********************************************************************
* For the execution of the static action we have to fill the table with an empty entry so that
* the logic is executed at all. Then the action is executed and confirmed with a commit.
* Finally, we read the database again to see if there are any records with EMPTY.
**********************************************************************

    DATA:
     lt_clear_streets TYPE TABLE FOR ACTION IMPORT zlc_r_partner~clearAllEmptyStreets.

    " Initial line
    lt_clear_streets = VALUE #( ( %cid = 'MyCID_1' ) ).
*    INSERT INITIAL LINE INTO TABLE lt_clear_streets.

    " Execute action
    MODIFY ENTITIES OF zlc_r_partner
      ENTITY Partner EXECUTE clearAllEmptyStreets
      FROM lt_clear_streets
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    " Commit
    COMMIT ENTITIES
      RESPONSE OF zlc_r_partner
      FAILED DATA(ls_commit_failed)
      REPORTED DATA(ls_commit_reported).

    " Read back to validate
    SELECT FROM zlc_dmo_partner
      FIELDS partner
      WHERE street = 'EMPTY'
      INTO TABLE @DATA(lt_empty_streets).

    " Assert
    cl_abap_unit_assert=>assert_subrc( exp = 4 ).

  ENDMETHOD.

ENDCLASS.
