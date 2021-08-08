CLASS zcl_conflu_obj_ddls DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_conflu_obj.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_conflu_obj_ddls IMPLEMENTATION.


  METHOD zif_conflu_obj~get_description.

    result = |{ NEW lcl_ddl_source( object_name )->get_name( ) } - { object_name } (Data definition)|.

  ENDMETHOD.


  METHOD zif_conflu_obj~get_documentation_levels.

    result = VALUE #(
                ( level = 1 name = 'Source Code Library' )
                ( level = 2 name = 'Core Data Services' )
                ( level = 3 name = 'Data Definition' ) ).

  ENDMETHOD.


  METHOD zif_conflu_obj~get_type.
    result = `DDLS`.
  ENDMETHOD.


  METHOD zif_conflu_obj~read_documentation.

  ENDMETHOD.


ENDCLASS.
