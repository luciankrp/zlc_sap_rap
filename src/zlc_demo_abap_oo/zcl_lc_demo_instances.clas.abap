CLASS zcl_lc_demo_instances DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
     react_for_different_objects
       IMPORTING
         io_object TYPE REF TO object
         io_output TYPE REF TO if_oo_adt_classrun_out
       RAISING
         cx_sy_conversion_unknown_unit.
ENDCLASS.



CLASS zcl_lc_demo_instances IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    " Reference to lcl_vehicle
    DATA lo_vehicle TYPE REF TO lcl_vehicle.

    " Instance of lcl_dacia
    lo_vehicle = NEW lcl_dacia( ).
    lo_vehicle->speed_up( out ).

    " Instance of lcl_car
    lo_vehicle = NEW lcl_car( ).
    lo_vehicle->speed_up( out ).

    " Cast Instance of lcl_car in order to access the open luggage method
    DATA(lo_casted_car) = CAST lcl_car( lo_vehicle ).
    lo_casted_car->open_luggage_space( out ).

    " Shorter
    CAST lcl_car( lo_vehicle )->open_luggage_space( out ).

*    DATA(lo_bmw) = NEW lcl_bmw( ).
*
*    IF lo_bmw IS INSTANCE OF lcl_vehicle.
*      out->write( 'LO_BMW is instance from object LCL_VEHICLE' ).
*    ENDIF.
*
*    DATA(lo_dog) = NEW lcl_dog( ).
*
*    IF lo_dog IS INSTANCE OF lif_animal.
*      out->write( 'LO_DOG is instance from interface LIF_ANIMAL' ).
*    ENDIF.
*
*    react_for_different_objects( io_output = out
*                                 io_object = NEW lcl_car( ) ).
*    react_for_different_objects( io_output = out
*                                 io_object = NEW lcl_truck( ) ).
*    react_for_different_objects( io_output = out
*                                 io_object = NEW lcl_bmw( ) ).
*    react_for_different_objects( io_output = out
*                                 io_object = NEW lcl_man( ) ).
*    react_for_different_objects( io_output = out
*                                 io_object = NEW lcl_plane( ) ).
*    react_for_different_objects( io_output = out
*                                 io_object = NEW lcl_dog( ) ).
*    react_for_different_objects( io_output = out
*                                 io_object = NEW lcl_cat( ) ).
  ENDMETHOD.

  METHOD react_for_different_objects.
    CASE TYPE OF io_object.
      WHEN TYPE lif_animal INTO DATA(lo_animal).
        lo_animal->make_sound( io_output ).

      WHEN TYPE lcl_car INTO DATA(lo_car).
        lo_car->open_luggage_space( io_output ).

      WHEN TYPE lcl_truck INTO DATA(lo_truck).
        lo_truck->open_bedroom( io_output ).

      WHEN TYPE lcl_vehicle INTO DATA(lo_vehicle).
        lo_vehicle->speed_up( io_output ).

      WHEN OTHERS.
        RAISE EXCEPTION NEW cx_sy_conversion_unknown_unit( ).

    ENDCASE.
  ENDMETHOD.

ENDCLASS.
