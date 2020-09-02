"! <p class="shorttext synchronized" lang="en">Constants</p>
INTERFACE zif_conflu_constants
  PUBLIC.

  CONSTANTS:
    rfc_destination TYPE rfcdest VALUE 'CONFLUENCE' ##NO_TEXT.

  CONSTANTS:
    BEGIN OF api_resources,
      spaces  TYPE string VALUE '/space' ##NO_TEXT,
      content TYPE string VALUE '/content' ##NO_TEXT,
    END OF api_resources.

ENDINTERFACE.
