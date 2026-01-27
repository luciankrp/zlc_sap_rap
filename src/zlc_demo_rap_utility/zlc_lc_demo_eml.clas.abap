CLASS zlc_lc_demo_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    METHODS:
      eml_read IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      eml_create IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      eml_update IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      eml_action IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      eml_rba IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      eml_cba IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      eml_delete IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zlc_lc_demo_eml IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " Read
*    me->eml_read( out ).

    " Create
*    me->eml_create( out ).

    " Update
*    me->eml_update( out ).

*    " Execute action via EML
*    me->eml_action( out ).

    " Create by association
    me->eml_cba( out ).

    " Read by association
    me->eml_rba( out ).

    " Delete
    me->eml_delete( out ).

  ENDMETHOD.

  METHOD eml_read.
**********************************************************************
* READ ENTITIES - Specification of the RAP business object, usually corresponds to the root node of the object.
* ENTITY - Specification of the entity to be read from the RAP object, the alias of the entity is particularly important here.
* FIELDS - Specification of the fields to be read as a table, expression of the fields or all fields.
* WITH - pass the keys to the read function, table is defined with "TABLE FOR READ IMPORT".
* RESULT - Table with the read data, can be created using an in line declaration and has the type "TABLE FOR READ RESULT".
* FAILED - Key of the erroneous entries if reading did not work.
* REPORTED - Contains error messages when there are problems reading.
**********************************************************************

    DATA: lt_selection TYPE TABLE FOR READ IMPORT zlc_r_partner.

    lt_selection = VALUE #(
      ( PartnerNumber = '1000000000' )
      ( PartnerNumber = '1000000002' ) ).

    READ ENTITIES OF zlc_r_partner ENTITY Partner
      ALL FIELDS WITH lt_selection
      RESULT DATA(lt_partner_long)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    out->write( lt_partner_long ).

    READ ENTITIES OF zlc_r_partner ENTITY Partner
      FIELDS ( PartnerName Street City ) WITH VALUE #(
        ( PartnerNumber = '1000000001' )
        ( PartnerNumber = '1000000003' ) )
      RESULT DATA(lt_partner)
      FAILED lt_failed
      REPORTED lt_reported.

    out->write( lt_partner ).

  ENDMETHOD.

  METHOD eml_create.
**********************************************************************
* MODIFY ENTITIES contains all important operations (Create, Update, Delete, Action)
* When filling the table we not only take over the data fields, but also fill in the CID and CONTROL fields.
* These fields are important so that the data in the object is correctly transferred:
* %CID - Dummy ID identifying a record within Create, Update and Delete. Can be assigned freely, but should be unambiguous.
* %CONTROL - Specifies which fields are taken into account during the operation.
*            If the fields in the structure are not active, no data is transferred and the new data record is empty.
* MAPPED - Return the changed key and mapping from CID to table key.
*          Especially important when the keys are generated within the business object.
**********************************************************************

    DATA: lt_creation TYPE TABLE FOR CREATE zlc_r_partner.

    lt_creation = VALUE #(
       (
         %cid = 'DummyKey1'
         PartnerNumber = '1999999999'
         PartnerName = 'Amazon'
         Country = 'US'
         %control-PartnerNumber = if_abap_behv=>mk-on
         %control-PartnerName = if_abap_behv=>mk-on
         %control-Country = if_abap_behv=>mk-on
        )
       ).

    MODIFY ENTITIES OF zlc_r_partner ENTITY Partner
      CREATE FROM lt_creation
      FAILED DATA(lt_failed)
      MAPPED DATA(lt_mapped)
      REPORTED DATA(lt_reported).

    TRY.
        out->write( lt_mapped-partner[ 1 ]-PartnerNumber ).
        COMMIT ENTITIES.

      CATCH cx_sy_itab_line_not_found.
        out->write( lt_failed-partner[ 1 ]-%cid ).
    ENDTRY.

  ENDMETHOD.

  METHOD eml_update.
**********************************************************************
* MODIFY ENTITIES contains all important operations (Create, Update, Delete, Action)
* When filling the table we not only take over the data fields, but also fill in the CONTROL fields.
* These fields are important so that the data in the object is correctly transferred:
* %CONTROL - Specifies which fields are taken into account during the operation.
*            If the fields in the structure are not active, no data is transferred and the new data record is empty.
* MAPPED - Return the changed key and mapping from CID to table key.
*          Especially important when the keys are generated within the business object.
**********************************************************************
    DATA: lt_update TYPE TABLE FOR UPDATE zlc_r_partner.

    lt_update = VALUE #(
      (
        PartnerNumber = '1000000000'
        PartnerName = 'SAP Fake'
        City = 'Munich'
        PaymentCurrency = 'EUR'
        %control-PaymentCurrency = if_abap_behv=>mk-on
        %control-City = if_abap_behv=>mk-on
       )
      ).

    MODIFY ENTITIES OF zlc_r_partner ENTITY Partner
      UPDATE FROM lt_update
      FAILED DATA(lt_failed)
      MAPPED DATA(lt_mapped)
      REPORTED DATA(lt_reported).

    IF lt_failed-partner IS INITIAL.
      out->write( 'Updated' ).
      COMMIT ENTITIES.
    ENDIF.

  ENDMETHOD.

  METHOD eml_action.
**********************************************************************
* Actions can also be triggered via EML using the MODIFY statement.
* Accordingly, you only have to specify the action to be triggered and the key of the data record.
* The RESULT is particularly important for the return, since the return is contained here.
**********************************************************************

    MODIFY ENTITIES OF zlc_r_partner
      ENTITY Partner EXECUTE fillEmptyStreets
      FROM VALUE #( ( PartnerNumber = '1000000008' ) )
      RESULT DATA(lt_result)
      MAPPED DATA(lt_mapped)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    IF line_exists( lt_result[ 1 ] ).
      out->write( lt_result[ 1 ]-PartnerNumber ).
      out->write( lt_result[ 1 ]-%param ).
    ELSE.
      out->write( 'Not worked' ).
    ENDIF.

  ENDMETHOD.

  METHOD eml_rba.
    " Read by association
    READ ENTITIES OF zlc_r_invoice

         ENTITY Invoice
         ALL FIELDS WITH VALUE #( ( %tky-%key-Document = '40000000' )
                                  ( %tky-%key-Document = '40000001' ) )
         RESULT DATA(lt_invoices)

         ENTITY Invoice BY \_Position
         FIELDS ( Material PositionNumber Price ) WITH VALUE #( ( %tky-%key-Document = '40000000' )
                                                                ( %tky-%key-Document = '40000001' ) )
         RESULT DATA(lt_positions)

         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(ls_failed).

    out->write( 'Invoices:' ).
    out->write( lt_invoices ).
    out->write( 'Positions:' ).
    out->write( lt_positions ).
  ENDMETHOD.

  METHOD eml_cba.

*    DATA:
*      lt_new_invoice  TYPE TABLE FOR CREATE zlc_r_invoice,
*      lt_new_position TYPE TABLE FOR CREATE zlc_r_invoice\_Position.


*    " Invoice
*    lt_new_invoice = VALUE #(
*        ( %cid = 'MyCID_1'
*          %key-Document = '40000000'
*          %data-Partner = '1000000008'
*          %control = VALUE #( Document = if_abap_behv=>mk-on Partner = if_abap_behv=>mk-on ) ) ).
*
*    " Position
*    lt_new_position = VALUE #(
*        ( %cid_ref = 'MyCID_1'
*          %target  = VALUE #(
*              ( %cid           = 'MyCID_P1'
*                PositionNumber = 1
*                Material       = 'R0001'
*                %control       = VALUE #( PositionNumber = if_abap_behv=>mk-on Material = if_abap_behv=>mk-on ) )
*              ( %cid           = 'MyCID_P1'
*                PositionNumber = 2
*                Price          = '2.20'
*                Currency       = 'EUR'
*                %control       = VALUE #( PositionNumber = if_abap_behv=>mk-on Price = if_abap_behv=>mk-on Currency = if_abap_behv=>mk-on ) ) ) ) ).

    " Create by association
    MODIFY ENTITIES OF zlc_r_invoice

      ENTITY Invoice CREATE FROM VALUE #(
        ( %cid = 'MyCID_1'
          %key-Document = '40000000'
          %data-Partner = '1000000008'
          %control = VALUE #( Document = if_abap_behv=>mk-on Partner = if_abap_behv=>mk-on ) )
        ( %cid = 'MyCID_2'
          %key-Document = '40000001'
          %data-Partner = '1000000000'
          %control = VALUE #( Document = if_abap_behv=>mk-on Partner = if_abap_behv=>mk-on ) ) )

      ENTITY Invoice CREATE BY \_Position FROM VALUE #(
        ( %cid_ref = 'MyCID_1'
          %target  = VALUE #(
              ( %cid           = 'MyCID_P1'
                PositionNumber = 1
                Material       = 'R0001'
                %control       = VALUE #( PositionNumber = if_abap_behv=>mk-on Material = if_abap_behv=>mk-on ) )
              ( %cid           = 'MyCID_P2'
                PositionNumber = 2
                Price          = '2.20'
                Currency       = 'EUR'
                %control       = VALUE #( PositionNumber = if_abap_behv=>mk-on Price = if_abap_behv=>mk-on Currency = if_abap_behv=>mk-on ) ) ) )
        ( %cid_ref = 'MyCID_2'
          %target  = VALUE #(
              ( %cid           = 'MyCID_P3'
                PositionNumber = 1
                Material       = 'R0002'
                %control       = VALUE #( PositionNumber = if_abap_behv=>mk-on Material = if_abap_behv=>mk-on ) )
              ( %cid           = 'MyCID_P4'
                PositionNumber = 2
                Price          = '3.15'
                Currency       = 'USD'
                %control       = VALUE #( PositionNumber = if_abap_behv=>mk-on Price = if_abap_behv=>mk-on Currency = if_abap_behv=>mk-on ) ) ) ) )

      FAILED DATA(ls_failed)
      MAPPED DATA(ls_mapped)
      REPORTED DATA(ls_reported).

    COMMIT ENTITIES.

    IF ls_failed-invoice IS NOT INITIAL.
      out->write( 'Failed!' ).
    ELSE.
      out->write( 'Creation OK' ).
    ENDIF.
  ENDMETHOD.

  METHOD eml_delete.

*    DATA lt_filter TYPE STANDARD TABLE OF zlc_r_invoice WITH EMPTY KEY.
*
*    lt_filter = VALUE #( ( Document = '40000001' ) ).

    "   Delete
    MODIFY ENTITIES OF zlc_r_invoice
      ENTITY Invoice
      DELETE FROM VALUE #( ( %tky-%key-Document = '40000001' ) )
      FAILED DATA(ls_failed).

    COMMIT ENTITIES.

    IF ls_failed-invoice IS NOT INITIAL.
      out->write( 'Failed!' ).
    ELSE.
      out->write( 'Deletion OK' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
