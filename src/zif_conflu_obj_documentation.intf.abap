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
      id     TYPE i,
      type   TYPE string,
      status TYPE string,
      title  TYPE string,
      url    TYPE string,
    END OF ts_page_info,
    tt_page_info TYPE SORTED TABLE OF ts_page_info WITH UNIQUE KEY id.

  METHODS get_space_info
    RETURNING
      VALUE(information) TYPE zif_conflu_obj_documentation=>ts_space_info
    RAISING
      zcx_conflu_export.

  METHODS get_page_info
    IMPORTING
      object_type        TYPE string
      object_name        TYPE string
    RETURNING
      VALUE(information) TYPE zif_conflu_obj_documentation=>ts_page_info
    RAISING
      zcx_conflu_export.

  METHODS export
    IMPORTING
      filter TYPE zif_conflu_obj_documentation=>tt_filter OPTIONAL
    RAISING
      zcx_conflu_export.

ENDINTERFACE.
