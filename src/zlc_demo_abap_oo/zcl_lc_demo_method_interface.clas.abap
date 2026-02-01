CLASS zcl_lc_demo_method_interface DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES tt_r_agency_id   TYPE RANGE OF /dmo/agency_id.
    TYPES tt_r_customer_id TYPE RANGE OF /dmo/customer_id.

    DATA mt_r_agency_id   TYPE tt_r_agency_id.
    DATA mt_r_customer_id TYPE tt_r_customer_id.

    CONSTANTS cs_lc_test TYPE string       VALUE 'LC Test'.
    CONSTANTS cs_test    TYPE abap_boolean VALUE 'X'.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lc_demo_method_interface IMPLEMENTATION.
ENDCLASS.
