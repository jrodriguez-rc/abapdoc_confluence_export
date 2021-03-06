CLASS zcl_conflu_obj_clas DEFINITION
  PUBLIC
  FINAL
  INHERITING FROM zcl_conflu_obj_oo
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_conflu_obj.

  PROTECTED SECTION.
    METHODS get_type
        REDEFINITION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_conflu_obj_clas IMPLEMENTATION.


  METHOD zif_conflu_obj~get_type.

    object_type = get_type( ).

  ENDMETHOD.


  METHOD zif_conflu_obj~get_documentation_levels.

    levels = get_documentation_levels( ).

  ENDMETHOD.


  METHOD zif_conflu_obj~get_description.

    description = get_description( object_name = object_name package = package ).

  ENDMETHOD.


  METHOD zif_conflu_obj~read_documentation.

    documentation = read_documentation( object_name = object_name package = package ).

  ENDMETHOD.


  METHOD get_type.

    object_type = 'CLAS'.

  ENDMETHOD.


ENDCLASS.
