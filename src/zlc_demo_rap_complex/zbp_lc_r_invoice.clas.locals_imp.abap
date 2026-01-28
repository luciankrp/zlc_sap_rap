CLASS lhc_Invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS send_mail_with_attachment
      IMPORTING
        iv_mail_content TYPE string
        iv_receiver     TYPE cl_bcs_mail_message=>ty_address.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Invoice RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Invoice RESULT result.
    METHODS sendEmail FOR MODIFY
      IMPORTING keys FOR ACTION Invoice~sendEmail.

ENDCLASS.

CLASS lhc_Invoice IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD sendEmail.
    READ ENTITIES OF ZLC_R_Invoice IN LOCAL MODE
         ENTITY Invoice
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_invoice).

    DATA lv_mail_content TYPE string.

    LOOP AT lt_invoice INTO DATA(ls_invoice).
      lv_mail_content &&= |Doc: { ls_invoice-Document }, From: { ls_invoice-Partner }\n|.
    ENDLOOP.

    send_mail_with_attachment( iv_mail_content = lv_mail_content
                               iv_receiver     = keys[ 1 ]-%param-Recipient ).
  ENDMETHOD.

  METHOD send_mail_with_attachment.
    DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).

    lo_mail->set_sender( 'BTP-noreply@CONNECT.com' ).
    lo_mail->add_recipient( iv_receiver ).

    lo_mail->set_subject( 'Invoices' ).
    lo_mail->set_main(
        cl_bcs_mail_textpart=>create_instance(
            iv_content      = '<h1>List of invoices</h1><p>See the attachment with the selected invoices.</p>'
            iv_content_type = 'text/html' ) ).

    lo_mail->add_attachment( cl_bcs_mail_textpart=>create_instance( iv_content      = iv_mail_content
                                                                    iv_content_type = 'text/plain'
                                                                    iv_filename     = 'Attachment.txt' ) ).

    lo_mail->send( ).
  ENDMETHOD.

ENDCLASS.
