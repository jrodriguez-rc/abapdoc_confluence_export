CLASS lcl_constants DEFINITION.

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF type,
        view             TYPE c LENGTH 1 VALUE `V`,
        extend           TYPE c LENGTH 1 VALUE `E`,
        table_function   TYPE c LENGTH 1 VALUE `F`,
        table_entity     TYPE c LENGTH 1 VALUE `T`,
        abstract_entityu TYPE c LENGTH 1 VALUE `A`,
        hierarchy        TYPE c LENGTH 1 VALUE `H`,
        custom_entity    TYPE c LENGTH 1 VALUE `Q`,
        projection_view  TYPE c LENGTH 1 VALUE `P`,
        extend_v2        TYPE c LENGTH 1 VALUE `X`,
        view_entity      TYPE c LENGTH 1 VALUE `W`,
      END OF type.

ENDCLASS.


CLASS lcl_ddl_source DEFINITION.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        ddlname TYPE ddlname
      RAISING
        zcx_conflu_docu.

    METHODS get_name
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_data,
        entity_annotation TYPE string,
        definition TYPE string,
        associations TYPE string,
      END OF ty_data.

    DATA:
      source TYPE ddddlsrcv.

    METHODS get_definition
      RETURNING
        VALUE(result) TYPE string.

ENDCLASS.
