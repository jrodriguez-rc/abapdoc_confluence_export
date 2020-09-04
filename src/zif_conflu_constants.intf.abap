"! <p class="shorttext synchronized" lang="en">Constants</p>
INTERFACE zif_conflu_constants
  PUBLIC.

  CONSTANTS:
    rfc_destination TYPE rfcdest VALUE 'CONFLUENCE' ##NO_TEXT.

  CONSTANTS:
    BEGIN OF api_resources,
      spaces  TYPE string VALUE '/space' ##NO_TEXT,
      content TYPE string VALUE '/content' ##NO_TEXT,
      labels  TYPE string VALUE '/content/<!PAGE!>/label' ##NO_TEXT,
    END OF api_resources.

  CONSTANTS:
    BEGIN OF api_method,
      get    TYPE string VALUE 'GET' ##NO_TEXT,
      post   TYPE string VALUE 'POST' ##NO_TEXT,
      put    TYPE string VALUE 'PUT' ##NO_TEXT,
      delete TYPE string VALUE 'DELETE' ##NO_TEXT,
    END OF api_method .

  CONSTANTS:
    BEGIN OF content_type,
      blog TYPE string VALUE 'blog' ##NO_TEXT,
      page TYPE string VALUE 'page' ##NO_TEXT,
    END OF content_type.

ENDINTERFACE.
