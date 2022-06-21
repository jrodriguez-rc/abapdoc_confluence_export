CLASS zcl_badi_conflu_export DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_badi_interface.
    INTERFACES zif_badi_conflu_export.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_badi_conflu_export IMPLEMENTATION.


  METHOD zif_badi_conflu_export~create_http_client.

    cl_http_client=>create_by_destination(
     EXPORTING
       destination              = zif_conflu_constants=>rfc_destination
     IMPORTING
       client                   = ri_result
     EXCEPTIONS
       argument_not_found       = 1
       destination_not_found    = 2
       destination_no_authority = 3
       plugin_not_active        = 4
       internal_error           = 5
       OTHERS                   = 6 ).
    IF sy-subrc <> 0.
      zcx_conflu_rest=>raise_system( ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_badi_conflu_export~get_api_key.

    " Redefine to fill API Key

  ENDMETHOD.


  METHOD zif_badi_conflu_export~get_base_uri.

    rv_result = `/rest/api`.

  ENDMETHOD.


ENDCLASS.
