"! <p class="shorttext synchronized" lang="en">Confluence Exporter APACK</p>
CLASS zcl_conflu_apack DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apack_manifest.

    CONSTANTS version     TYPE string VALUE '1.0.0' ##NO_TEXT.
    CONSTANTS group       TYPE string VALUE 'github.com/jrodriguez-rc' ##NO_TEXT.
    CONSTANTS artifact_id TYPE string VALUE 'abapdoc_confluence_export' ##NO_TEXT.
    CONSTANTS repository  TYPE string VALUE 'https://github.com/jrodriguez-abapdoc_confluence_export.git' ##NO_TEXT.

    "! <p class="shorttext synchronized" lang="en">CONSTRUCTOR</p>
    "!
    METHODS constructor.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_conflu_apack IMPLEMENTATION.


  METHOD constructor.

    if_apack_manifest~descriptor = VALUE #( group_id    = group
                                             artifact_id = artifact_id
                                             version     = version
                                             git_url     = repository ).

  ENDMETHOD.


ENDCLASS.
