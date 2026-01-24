CLASS lsc_zlc_r_partner DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zlc_r_partner IMPLEMENTATION.

  METHOD adjust_numbers.
**********************************************************************
* Late numbering - The late number assignment only occurs in the storage sequence of the framework,
* just before the data is written to the database.
* At this point you can assign a number by number range or assign the key in another way.
**********************************************************************
* The implementation of the automatic number assignment is not rocket science and only requires a few small steps.
* When designing the RAP business objects, you should think about what type of keys you want to use.
* No matter whether UUID or number range, the automatic assignment takes a lot of work.
**********************************************************************

    " Get max Partner id
    SELECT FROM zlc_dmo_partner
      FIELDS MAX( Partner  )
      INTO @DATA(lv_max_partner).

    " Map new Partner id
    LOOP AT mapped-partner REFERENCE INTO DATA(lr_partner).
      lv_max_partner += 1.
      lr_partner->PartnerNumber = lv_max_partner.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Partner DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Partner RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Partner RESULT result.

    METHODS validateKeyIsFilled FOR VALIDATE ON SAVE
      IMPORTING keys FOR Partner~validateKeyIsFilled.

    METHODS validateCoreData FOR VALIDATE ON SAVE
      IMPORTING keys FOR Partner~validateCoreData.

    METHODS fillCurrency FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Partner~fillCurrency.

    METHODS clearAllEmptyStreets FOR MODIFY
      IMPORTING keys FOR ACTION Partner~clearAllEmptyStreets.

    METHODS fillEmptyStreets FOR MODIFY
      IMPORTING keys FOR ACTION Partner~fillEmptyStreets RESULT result.

    METHODS copyLine FOR MODIFY
      IMPORTING keys FOR ACTION Partner~copyLine.

    METHODS withPopup FOR MODIFY
      IMPORTING keys FOR ACTION Partner~withPopup.

ENDCLASS.

CLASS lhc_Partner IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validateKeyIsFilled.
**********************************************************************
* They are triggered when the data is saved and can be registered for the individual events such as create, update and delete.
* Furthermore, there is also the possibility that a validation is only triggered when a single field is changed.
* The general validation refers to validations that are always triggered when saving certain events (Create, Update, Delete).
**********************************************************************

* Commented out due to Late Numbering (ADJUST_NUMBERS method)
*    LOOP AT keys INTO DATA(ls_key) USING KEY entity WHERE  PartnerNumber IS INITIAL.
*
*      " Who failed
*      failed-partner = VALUE #( BASE failed-partner ( %tky-PartnerNumber = ls_key-%tky-PartnerNumber ) ).
*
*      " Message and mark element
*      reported-partner = VALUE #( BASE reported-partner (
*                            %tky-%key-PartnerNumber = ls_key-%tky-PartnerNumber
*                            %element-%field-PartnerNumber = if_abap_behv=>mk-on
*                            %msg = new_message_with_text(
*                                     severity = if_abap_behv_message=>severity-error
*                                     text     = 'Partner Number is mandatory'
*                                   ) ) ).
*
*    ENDLOOP.

  ENDMETHOD.

  METHOD validateCoreData.
**********************************************************************
* They are triggered when the data is saved and can be registered for the individual events such as create, update and delete.
* Furthermore, there is also the possibility that a validation is only triggered when a single field is changed.
* The next validation is only triggered when the corresponding field changes.
* This is particularly useful when we check against interfaces or tables whether this value exists in order to save performance.
**********************************************************************

*   Read all
    READ ENTITIES OF zlc_r_partner IN LOCAL MODE
      ENTITY Partner
      FIELDS ( Country PaymentCurrency )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_partner).

*   Find currency
    SELECT Currency
      FROM I_Currency
      FOR ALL ENTRIES IN @lt_partner
      WHERE Currency = @lt_partner-PaymentCurrency
      INTO TABLE @DATA(lt_currency).

*   Find country
    SELECT Country
      FROM I_Country
      FOR ALL ENTRIES IN @lt_partner
      WHERE Country = @lt_partner-Country
      INTO TABLE @DATA(lt_country).


    LOOP AT lt_partner INTO DATA(ls_partner).

      " Currency not valid
      IF NOT line_exists( lt_currency[ Currency = ls_partner-PaymentCurrency ]  )
         AND ls_partner-%data-PaymentCurrency IS NOT INITIAL.

        failed-partner = VALUE #( BASE failed-partner ( %tky-%key-PartnerNumber = ls_partner-%tky-%key-PartnerNumber ) ).

        reported-partner = VALUE #( BASE reported-partner (
                              %tky-%key-PartnerNumber = ls_partner-%tky-%key-PartnerNumber
                              %element-%field-PaymentCurrency = if_abap_behv=>mk-on
                              %msg = new_message_with_text(
                                       severity = if_abap_behv_message=>severity-error
                                       text     = 'Currency not valid'
                                     ) ) ).

      ENDIF.

      " Country not valid
      IF NOT line_exists( lt_country[ Country = ls_partner-Country ]  )
         AND ls_partner-%data-Country IS NOT INITIAL.

        failed-partner = VALUE #( BASE failed-partner ( %tky-%key-PartnerNumber = ls_partner-%tky-%key-PartnerNumber ) ).

        reported-partner = VALUE #( BASE reported-partner (
                              %tky-%key-PartnerNumber = ls_partner-%tky-%key-PartnerNumber
                              %element-%field-Country = if_abap_behv=>mk-on
                              %msg = new_message_with_text(
                                       severity = if_abap_behv_message=>severity-error
                                       text     = 'Country not valid'
                                     ) ) ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD fillCurrency.
**********************************************************************
* A determination can take the work out of filling in fields with information that might come from other data sources.
* Or information is derived if the user forgets to fill it in.
* A determination can be simple or complex, but in the end it also ensures that the data in the business object is complete.
**********************************************************************

    " Read all
    READ ENTITIES OF zlc_r_partner IN LOCAL MODE
      ENTITY Partner
      FIELDS ( PaymentCurrency )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_partners).

    " Remove if currency not empty
    DELETE lt_partners WHERE %data-PaymentCurrency IS NOT INITIAL.

    " Default (always use %control)
    MODIFY ENTITIES OF zlc_r_partner IN LOCAL MODE
      ENTITY Partner
      UPDATE FIELDS ( PaymentCurrency )
      WITH VALUE #( FOR ls_partner IN lt_partners (
                        %tky-%key-PartnerNumber = ls_partner-%tky-%key-PartnerNumber
                        %data-PaymentCurrency = 'EUR'
                        %control-PaymentCurrency = if_abap_behv=>mk-on ) ).

  ENDMETHOD.

  METHOD clearAllEmptyStreets.
**********************************************************************
* The [Static] action is always active because it affects the entire object and is not dependent on a selected data record.
* The action is correspondingly different, because here we have to read all the keys ourselves
* from the database and are not handed them over.
**********************************************************************

    " Get empty streets
    SELECT FROM zlc_dmo_partner
      FIELDS partner, street
      WHERE street = 'EMPTY'
      INTO TABLE @DATA(lt_partners).

    " Update
    MODIFY ENTITIES OF zlc_r_partner IN LOCAL MODE
      ENTITY Partner
      UPDATE FIELDS ( Street )
      WITH VALUE #( FOR ls_partner IN lt_partners (
             %tky-%key-PartnerNumber = ls_partner-partner
             %control-Street = if_abap_behv=>mk-on
             %data-Street = '' ) )
      MAPPED mapped
      FAILED failed
      REPORTED reported.

    " Message text
    DATA(lv_msg) = |{ lines( lt_partners ) } record(s) changed|.

    " Display message
    reported-partner = VALUE #( (
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-success
                                 text     = lv_msg
                               ) ) ).

*    " Report message (duplicates when more than 1 entry changed)
*    reported-partner = VALUE #( FOR ls_partner IN lt_partners (
*                        %tky-%key-PartnerNumber = ls_partner-partner
*                        %msg = new_message_with_text(
*                                 severity = if_abap_behv_message=>severity-success
*                                 text     = lv_msg
*                               ) ) ).
  ENDMETHOD.

  METHOD fillEmptyStreets.
**********************************************************************
* The normal action is initially inactive and can only be used once one or more records in the list have been selected.
* The action is only performed on this record.
**********************************************************************

    " Update
    MODIFY ENTITIES OF zlc_r_partner IN LOCAL MODE
      ENTITY Partner
      UPDATE FIELDS ( Street )
      WITH VALUE #( FOR ls_key IN keys (
             %cid_ref = ls_key-%cid_ref
             %tky-%key-PartnerNumber = ls_key-%tky-%key-PartnerNumber
             %control-Street = if_abap_behv=>mk-on
             %data-Street = 'EMPTY' ) )
      MAPPED mapped
      FAILED failed
      REPORTED reported.

    " Report message
    reported-partner = VALUE #( FOR ls_key IN keys (
                        %tky-%key-PartnerNumber = ls_key-%tky-%key-PartnerNumber
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-success
                                 text     = 'Street updated successfully'
                               ) ) ).

    " Read back
    READ ENTITIES OF zlc_r_partner IN LOCAL MODE
      ENTITY Partner
      FIELDS ( PartnerNumber Street )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    " Result (because we added this to the action - result [1] $self;)
    result = VALUE #( FOR ls_result IN lt_result (
                %tky-%key-PartnerNumber = ls_result-%tky-%key-PartnerNumber
                %param = ls_result ) ).

  ENDMETHOD.

  METHOD copyLine.
**********************************************************************
* The [Factory] action generates an instance of the current entity, which can happen when copying, among other things.
* A cardinality is given at the end, but the "result" can be omitted, since $self is always used.
**********************************************************************

    " Read all
    READ ENTITIES OF zlc_r_partner IN LOCAL MODE
      ENTITY Partner
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_partners).

    " Get Max Partner id
    SELECT FROM zlc_dmo_partner
      FIELDS MAX( partner )
      INTO @DATA(lv_number).

    " Create copies
    MODIFY ENTITIES OF zlc_r_partner IN LOCAL MODE
      ENTITY Partner CREATE
      FROM VALUE #( FOR ls_partner IN lt_partners (
                      %cid = keys[ sy-tabix ]-%cid
                      %key-PartnerNumber = lv_number + 1
                      %data-PartnerName = ls_partner-PartnerName  && | copy|
                      %control-PartnerNumber = if_abap_behv=>mk-on
                      %control-PartnerName = if_abap_behv=>mk-on
                      %control-Street = if_abap_behv=>mk-on
                      %control-City = if_abap_behv=>mk-on
                      %control-Country = if_abap_behv=>mk-on
                      %control-PaymentCurrency = if_abap_behv=>mk-on  ) )
      FAILED failed
      REPORTED reported
      MAPPED mapped.

  ENDMETHOD.

  METHOD withPopup.
**********************************************************************
* To implement a pop up for an action, you must pass the entity as a parameter.
* The addition "parameter" ensures that a pop up is generated for the entity behind it
* and the fields are queried before the action is executed.
**********************************************************************

    TRY.
        DATA(ls_key) = keys[ 1 ].
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.

    CASE ls_key-%param-MessageType.
      WHEN 1.
        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Dummy message' )
        ) INTO TABLE reported-partner.
      WHEN 2.
        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information text = 'Dummy message' )
        ) INTO TABLE reported-partner.
      WHEN 3.
        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning text = 'Dummy message' )
        ) INTO TABLE reported-partner.
      WHEN 4.
        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Dummy message' )
        ) INTO TABLE reported-partner.
      WHEN 5.
        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-none text = 'Dummy message' )
        ) INTO TABLE reported-partner.
      WHEN 6.
        reported-partner = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Dummy message' ) )
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information text = 'Dummy message' ) )
        ).
      WHEN 7. " The positive messages have been filtered and only warnings and errors can be seen
        reported-partner = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Dummy message' ) )
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Dummy message' ) )
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning text = 'Dummy message' ) )
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information text = 'Dummy message' ) )
        ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
