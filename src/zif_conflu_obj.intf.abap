"! <p class="shorttext synchronized" lang="en">Export Objects documentation</p>
INTERFACE zif_conflu_obj
  PUBLIC.

  TYPES:
    BEGIN OF ts_documentation_level,
      level TYPE i,
      name  TYPE string,
    END OF ts_documentation_level,
    tt_documentation_level TYPE SORTED TABLE OF ts_documentation_level WITH UNIQUE KEY level.

  METHODS get_type
    RETURNING
      VALUE(object_type) TYPE trobjtype.

  METHODS read_documentation
    IMPORTING
      repository_object    TYPE tadir
    RETURNING
      VALUE(documentation) TYPE string.

  METHODS get_documentation_levels
    RETURNING
      VALUE(levels) TYPE zif_conflu_obj=>tt_documentation_level.

ENDINTERFACE.
