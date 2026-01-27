""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The elements receive their own keyword in the CDS view and again receive the annotation to indicate the implementing class.
" These virtual elements can only be used in the projection layer and will result in an error for a view or standard entity.
" The class is implemented accordingly with the interface IF_SADL_EXIT_CALC_ELEMENT_READ.
" It is sufficient to fill the CALCULATE method with content.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Hint: Virtual elements are implemented quite simply, but information from JOIN and association should be used preferably.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
CLASS zcl_lc_demo_ve_exit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lc_demo_ve_exit IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    " All virtual elements
    LOOP AT it_requested_calc_elements INTO DATA(lv_virtual_field).

      " Calculate for each element
      LOOP AT ct_calculated_data ASSIGNING FIELD-SYMBOL(<ls_calculated_data>).

        " Index
        DATA(lv_tabix) = sy-tabix.

        " Virtual element - prepare for change
        ASSIGN COMPONENT lv_virtual_field OF STRUCTURE <ls_calculated_data> TO FIELD-SYMBOL(<lv_field>).

        " Read entire line
        DATA(ls_original) = CORRESPONDING ZLC_C_Invoice( it_original_data[ lv_tabix ] ).

        " Calculate and assign value
        IF ls_original-Partner = '1000000002'.
          <lv_field> = 999. " default to 999
        ELSE.
          SELECT FROM zlc_dmo_position
            FIELDS COUNT( * )
            WHERE document = @ls_original-Document
            INTO @<lv_field>. " number of records
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
