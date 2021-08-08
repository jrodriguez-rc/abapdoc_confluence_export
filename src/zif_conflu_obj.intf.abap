"! <p class="shorttext synchronized" lang="en">Export Objects documentation</p>
INTERFACE zif_conflu_obj
  PUBLIC.

  TYPES:
    BEGIN OF ty_documentation_level,
      level           TYPE i,
      name            TYPE string,
      default_content TYPE string,
    END OF ty_documentation_level,
    ty_documentation_levels TYPE SORTED TABLE OF ty_documentation_level WITH UNIQUE KEY level.

  METHODS get_type
    RETURNING
      VALUE(result) TYPE trobjtype.

  METHODS get_documentation_levels
    RETURNING
      VALUE(result) TYPE zif_conflu_obj=>ty_documentation_levels.

  METHODS get_description
    IMPORTING
      object_name   TYPE sobj_name
      package       TYPE devclass
    RETURNING
      VALUE(result) TYPE string
    RAISING
      zcx_conflu_docu.

  METHODS read_documentation
    IMPORTING
      object_name   TYPE sobj_name
      package       TYPE devclass
    RETURNING
      VALUE(result) TYPE string
    RAISING
      zcx_conflu_docu.

ENDINTERFACE.
