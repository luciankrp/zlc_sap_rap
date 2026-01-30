CLASS zcl_lc_demo_unmanaged_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

protected section.
  PRIVATE SECTION.
    METHODS get_data_from_request
      IMPORTING io_request       TYPE REF TO if_rap_query_request
      RETURNING VALUE(rt_result) TYPE zif_lc_demo_rap_data_handler=>tt_data
      RAISING   cx_rap_query_filter_no_range.
ENDCLASS.

CLASS ZCL_LC_DEMO_UNMANAGED_QUERY IMPLEMENTATION.
  METHOD get_data_from_request.
    DATA lt_r_key  TYPE zif_lc_demo_rap_data_handler=>tt_r_key.
    DATA lt_r_text TYPE zif_lc_demo_rap_data_handler=>tt_r_text.
    DATA lt_r_date TYPE zif_lc_demo_rap_data_handler=>tt_r_date.

    DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(ld_offset) = io_request->get_paging( )->get_offset( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(ld_pagesize) = io_request->get_paging( )->get_page_size( ).

    LOOP AT lt_filter INTO DATA(ls_filter).
      CASE ls_filter-name.
        WHEN 'TABLEKEY'.
          lt_r_key = CORRESPONDING #( ls_filter-range ).
        WHEN 'DESCRIPTION'.
          lt_r_text = CORRESPONDING #( ls_filter-range ).
        WHEN 'CREATIONDATE'.
          lt_r_date = CORRESPONDING #( ls_filter-range ).
      ENDCASE.
    ENDLOOP.

    rt_result = zcl_lc_demo_rap_data_handler=>create_instance( )->query( it_r_key  = lt_r_key
                                                                         it_r_text = lt_r_text
                                                                         it_r_date = lt_r_date ).
  ENDMETHOD.

  METHOD if_rap_query_provider~select.
    DATA lt_output TYPE STANDARD TABLE OF ZLC_C_DMOUnmanaged.

    TRY.
        DATA(lt_database) = get_data_from_request( io_request ).
      CATCH cx_rap_query_filter_no_range.
        " handle exception
    ENDTRY.
    lt_output = CORRESPONDING #( lt_database MAPPING TableKey = gen_key Description = text CreationDate = cdate ).

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_output ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( lt_output ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
