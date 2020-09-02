CLASS zcl_conflu_obj_clas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_conflu_obj.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_conflu_obj_clas IMPLEMENTATION.


  METHOD zif_conflu_obj~get_type.

    object_type = 'CLAS'.

  ENDMETHOD.


  METHOD zif_conflu_obj~get_documentation_levels.

    levels = VALUE #( ( level = 1 name = 'Source Code Library' )
                      ( level = 2 name = 'Classes' ) ).

  ENDMETHOD.


  METHOD zif_conflu_obj~read_documentation.

  ENDMETHOD.


ENDCLASS.
