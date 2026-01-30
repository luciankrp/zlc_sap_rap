INTERFACE zif_lc_demo_rap_data_handler
  PUBLIC.

  TYPES tt_r_key  TYPE RANGE OF zlc_dmo_un_data-gen_key.
  TYPES tt_r_text TYPE RANGE OF zlc_dmo_un_data-text.
  TYPES tt_r_date TYPE RANGE OF zlc_dmo_un_data-cdate.

  TYPES ts_data   TYPE zlc_dmo_un_data.
  TYPES tt_data   TYPE STANDARD TABLE OF ts_data WITH EMPTY KEY.

  METHODS query
    IMPORTING it_r_key         TYPE tt_r_key  OPTIONAL
              it_r_text        TYPE tt_r_text OPTIONAL
              it_r_date        TYPE tt_r_date OPTIONAL
    RETURNING VALUE(rt_result) TYPE tt_data.

  METHODS read
    IMPORTING id_key           TYPE zlc_dmo_unmgnd-gen_key
    RETURNING VALUE(rs_result) TYPE ts_data.

  METHODS modify
    IMPORTING is_data          TYPE ts_data
    RETURNING VALUE(rd_result) TYPE abap_boolean.

  METHODS delete
    IMPORTING id_key           TYPE zlc_dmo_unmgnd-gen_key
    RETURNING VALUE(rd_result) TYPE abap_boolean.
ENDINTERFACE.
