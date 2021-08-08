CLASS lcl_constants DEFINITION.

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF type,
        view             TYPE ddddlsrctype VALUE `V`,
        extend           TYPE ddddlsrctype VALUE `E`,
        table_function   TYPE ddddlsrctype VALUE `F`,
        table_entity     TYPE ddddlsrctype VALUE `T`,
        abstract_entityu TYPE ddddlsrctype VALUE `A`,
        hierarchy        TYPE ddddlsrctype VALUE `H`,
        custom_entity    TYPE ddddlsrctype VALUE `Q`,
        projection_view  TYPE ddddlsrctype VALUE `P`,
        extend_v2        TYPE ddddlsrctype VALUE `X`,
        view_entity      TYPE ddddlsrctype VALUE `W`,
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
