CLASS zlc_lc_demo_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    METHODS:
      eml_read IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      eml_create IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      eml_update IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
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

ENDCLASS.
