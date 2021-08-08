"! <p class="shorttext synchronized" lang="en">Export Interface documentation</p>
CLASS zcl_conflu_obj_intf DEFINITION
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



CLASS zcl_conflu_obj_intf IMPLEMENTATION.


  METHOD zif_conflu_obj~get_type.

    result = get_type( ).

  ENDMETHOD.


  METHOD zif_conflu_obj~get_documentation_levels.

    result = get_documentation_levels( ).

  ENDMETHOD.


  METHOD zif_conflu_obj~get_description.

    result = get_description( object_name = object_name package = package ).

  ENDMETHOD.


  METHOD zif_conflu_obj~read_documentation.

    result = read_documentation( object_name = object_name package = package ).

  ENDMETHOD.


  METHOD get_type.

    result = 'INTF'.

  ENDMETHOD.


ENDCLASS.
