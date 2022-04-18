INTERFACE zif_badi_conflu_export
  PUBLIC.

  INTERFACES if_badi_interface.

  METHODS create_http_client
    IMPORTING
      iv_space_key     TYPE string
      iv_package       TYPE devclass
    RETURNING
      VALUE(ri_result) TYPE REF TO if_http_client
    RAISING
      zcx_conflu_rest.

  METHODS get_base_uri
    IMPORTING
      iv_space_key     TYPE string
      iv_package       TYPE devclass
    RETURNING
      VALUE(rv_result) TYPE string.

ENDINTERFACE.
