"! <p class="shorttext synchronized" lang="en">Objects documentation</p>
INTERFACE zif_conflu_obj_documentation
  PUBLIC.

  TYPES:
    BEGIN OF ts_filter,
      object_type TYPE trobjtype,
      object_name TYPE sobj_name,
    END OF ts_filter,
    tt_filter TYPE STANDARD TABLE OF zif_conflu_obj_documentation=>ts_filter WITH DEFAULT KEY.

  TYPES:
    BEGIN OF ts_space_info,
      id   TYPE i,
      key  TYPE string,
      name TYPE string,
      type TYPE string,
      url  TYPE string,
    END OF ts_space_info.

  TYPES:
    BEGIN OF ts_page_info,
      id      TYPE i,
      type    TYPE string,
      status  TYPE string,
      title   TYPE string,
      version TYPE i,
      url     TYPE string,
    END OF ts_page_info,
    tt_page_info TYPE SORTED TABLE OF ts_page_info WITH UNIQUE KEY id.

  TYPES:
    BEGIN OF ts_documentation_level,
      level           TYPE i,
      name            TYPE string,
      default_content TYPE string,
      page_info       TYPE zif_conflu_obj_documentation=>ts_page_info,
    END OF ts_documentation_level,
    tt_documentation_level TYPE SORTED TABLE OF ts_documentation_level WITH UNIQUE KEY level.

  TYPES:
    BEGIN OF ts_label,
      name TYPE string,
    END OF ts_label,
    tt_labels TYPE STANDARD TABLE OF ts_label WITH DEFAULT KEY.

  TYPES:
    BEGIN OF ts_json_documentation,
      object_type TYPE trobjtype,
      object_name TYPE sobj_name,
      package     TYPE devclass,
      content     TYPE string,
    END OF ts_json_documentation,
    tt_json_documentation TYPE HASHED TABLE OF ts_json_documentation WITH UNIQUE KEY object_type object_name.

  METHODS        get_space_info
    RETURNING
      VALUE(information) TYPE zif_conflu_obj_documentation=>ts_space_info
    RAISING
      zcx_conflu_docu
      zcx_conflu_rest.

  METHODS get_page_info
    IMPORTING
      object_type        TYPE string
      object_name        TYPE string
    RETURNING
      VALUE(information) TYPE zif_conflu_obj_documentation=>ts_page_info
    RAISING
      zcx_conflu_docu
      zcx_conflu_rest.

  METHODS get_documentation_levels
    IMPORTING
      object_type   TYPE string
    RETURNING
      VALUE(levels) TYPE zif_conflu_obj_documentation=>tt_documentation_level
    RAISING
      zcx_conflu_docu
      zcx_conflu_rest.

  METHODS export
    IMPORTING
      filter TYPE zif_conflu_obj_documentation=>tt_filter OPTIONAL
    RAISING
      zcx_conflu_export
      zcx_conflu_docu
      zcx_conflu_rest.

  METHODS generate_json
    IMPORTING
      filter        TYPE zif_conflu_obj_documentation=>tt_filter OPTIONAL
      antecesor     TYPE i OPTIONAL
    RETURNING
      VALUE(result) TYPE tt_json_documentation
    RAISING
      zcx_conflu_export
      zcx_conflu_docu
      zcx_conflu_rest.

ENDINTERFACE.
