*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

" Class Definitions
CLASS lcl_vehicle DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      speed_up
        IMPORTING
          io_output TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.

CLASS lcl_dacia DEFINITION INHERITING FROM lcl_vehicle.

ENDCLASS.

CLASS lcl_car DEFINITION INHERITING FROM lcl_vehicle.
  PUBLIC SECTION.
    METHODS:
      open_luggage_space
        IMPORTING
          io_output TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.

CLASS lcl_bmw DEFINITION INHERITING FROM lcl_car.
ENDCLASS.

CLASS lcl_truck DEFINITION.
  PUBLIC SECTION.
    METHODS open_bedroom
      IMPORTING io_output TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.

CLASS lcl_man DEFINITION INHERITING FROM lcl_truck.
ENDCLASS.

CLASS lcl_plane DEFINITION INHERITING FROM lcl_vehicle.
ENDCLASS.

INTERFACE lif_animal.
  METHODS:
    make_sound
      IMPORTING io_output TYPE REF TO if_oo_adt_classrun_out.
ENDINTERFACE.

CLASS lcl_cat DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_animal.
ENDCLASS.

CLASS lcl_dog DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_animal.
ENDCLASS.


" Class Implementations
CLASS lcl_vehicle IMPLEMENTATION.
  METHOD speed_up.
    io_output->write( 'Over 9000!' ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_car IMPLEMENTATION.
  METHOD open_luggage_space.
    io_output->write( 'I am opening the luggage space.' ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_truck IMPLEMENTATION.
  METHOD open_bedroom.
    io_output->write( 'I am opening the bedroom.' ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_cat IMPLEMENTATION.

  METHOD lif_animal~make_sound.
    io_output->write( 'Miau!' ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_dog IMPLEMENTATION.
  METHOD lif_animal~make_sound.
    io_output->write( 'Wuff!' ).
  ENDMETHOD.

ENDCLASS.
