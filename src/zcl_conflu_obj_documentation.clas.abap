"! <p class="shorttext synchronized" lang="en">Export Objects documentation</p>
CLASS zcl_conflu_obj_documentation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_conflu_obj_documentation.

    CLASS-METHODS create
      IMPORTING
        space_key                   TYPE string
        package                     TYPE devclass
      RETURNING
        VALUE(object_documentation) TYPE REF TO zif_conflu_obj_documentation
      RAISING
        zcx_conflu.

    METHODS constructor
      IMPORTING
        space_key TYPE string
        package   TYPE devclass
      RAISING
        zcx_conflu.

  PROTECTED SECTION.
    METHODS get_auth_token
      RETURNING
        VALUE(token) TYPE string.

    METHODS get_space_uri
      RETURNING
        VALUE(uri) TYPE string.

    METHODS get_content_uri
      RETURNING
        VALUE(uri) TYPE string.

    METHODS get_page_childs_uri
      IMPORTING
        parent     TYPE i
      RETURNING
        VALUE(uri) TYPE string.

    METHODS deserialize_space_info
      IMPORTING
        content           TYPE string
      RETURNING
        VALUE(space_info) TYPE zif_conflu_obj_documentation=>ts_space_info.

    METHODS deserialize_pages_info
      IMPORTING
        content           TYPE string
      RETURNING
        VALUE(pages_info) TYPE zif_conflu_obj_documentation=>tt_page_info.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ts_exporter,
        type   TYPE trobjtype,
        object TYPE REF TO zif_conflu_obj,
      END OF ts_exporter,
      tt_exporter TYPE SORTED TABLE OF ts_exporter WITH UNIQUE KEY type,

      BEGIN OF ts_documentation,
        object_type TYPE trobjtype,
        object_name TYPE sobj_name,
        content     TYPE string,
      END OF ts_documentation,
      tt_documentation TYPE HASHED TABLE OF ts_documentation WITH UNIQUE KEY object_type object_name,

      tt_tadir         TYPE HASHED TABLE OF tadir WITH UNIQUE KEY pgmid object obj_name.

    DATA:
      space_key TYPE string,
      package   TYPE devclass,
      exporters TYPE tt_exporter.

    METHODS create_rest_client
      IMPORTING
        uri                TYPE string
      RETURNING
        VALUE(rest_client) TYPE REF TO cl_rest_http_client.

    METHODS read_repository_objects
      IMPORTING
        filters        TYPE zif_conflu_obj_documentation=>tt_filter
      RETURNING
        VALUE(objects) TYPE tt_tadir.

    METHODS load_export_objects
      RAISING
        zcx_conflu_export.

    METHODS export_documentation
      IMPORTING
        space_key     TYPE string
        documentation TYPE tt_documentation
      RAISING
        zcx_conflu_export.

    METHODS search_page
      IMPORTING
        title            TYPE string
      RETURNING
        VALUE(page_info) TYPE zif_conflu_obj_documentation=>ts_page_info.

    METHODS search_child_page
      IMPORTING
        parent           TYPE i
        title            TYPE string
        wildcard         TYPE abap_bool OPTIONAL
      RETURNING
        VALUE(page_info) TYPE zif_conflu_obj_documentation=>ts_page_info.

ENDCLASS.



CLASS zcl_conflu_obj_documentation IMPLEMENTATION.


  METHOD create.

    object_documentation = NEW zcl_conflu_obj_documentation( space_key = space_key package = package ).

  ENDMETHOD.

  METHOD constructor.

    me->space_key = space_key.
    me->package   = package.

    load_export_objects( ).

  ENDMETHOD.


  METHOD zif_conflu_obj_documentation~get_space_info.

    DATA(rest_client) = create_rest_client( get_space_uri( ) ).

    rest_client->if_rest_resource~get( ).

    DATA(info_json) = rest_client->if_rest_client~get_response_entity( )->get_string_data( ).

    information = deserialize_space_info( info_json ).

  ENDMETHOD.


  METHOD zif_conflu_obj_documentation~get_page_info.

    DATA:
      parent_page TYPE zif_conflu_obj_documentation=>ts_page_info.

    TRY.
        DATA(object_documentation) = exporters[ type = object_type ]-object.
      CATCH cx_sy_itab_line_not_found.
        RETURN. " TODO: Raise an exception - Object not supported
    ENDTRY.

    DATA(levels) = object_documentation->get_documentation_levels( ).

    LOOP AT levels REFERENCE INTO DATA(level).

      parent_page = COND #( WHEN level->level = 1
                                THEN search_page( level->name )
                                ELSE search_child_page( parent = parent_page-id title = level->name ) ).

      IF parent_page IS INITIAL.
        EXIT.
      ENDIF.

    ENDLOOP.

    IF levels IS NOT INITIAL AND parent_page IS INITIAL.
      RETURN. " TODO: Raise an exception - Object not supported
    ENDIF.

  ENDMETHOD.


  METHOD zif_conflu_obj_documentation~export.

    DATA(documentation) = VALUE tt_documentation( ).

    LOOP AT read_repository_objects( filter ) REFERENCE INTO DATA(object).

      TRY.
          DATA(object_documentation) = exporters[ type = object->object ]-object.
        CATCH cx_sy_itab_line_not_found.
          CONTINUE.
      ENDTRY.

      INSERT VALUE ts_documentation(
          object_type = object->object
          object_name = object->obj_name
          content     = object_documentation->read_documentation( object->* ) ) INTO TABLE documentation.

    ENDLOOP.

    export_documentation( space_key     = space_key
                          documentation = documentation ).

  ENDMETHOD.


  METHOD get_space_uri.

    uri = |{ zif_conflu_constants=>api_resources-spaces }/{ space_key }|.

  ENDMETHOD.


  METHOD get_content_uri.

    uri = |{ zif_conflu_constants=>api_resources-content }|.

  ENDMETHOD.


  METHOD get_page_childs_uri.

    uri = |{ get_content_uri( ) }/{ parent ZERO = NO }/child/page|.

  ENDMETHOD.


  METHOD get_auth_token.
  ENDMETHOD.


  METHOD create_rest_client.

    cl_http_client=>create_by_destination(
     EXPORTING
       destination              = zif_conflu_constants=>rfc_destination
     IMPORTING
       client                   = DATA(http_client)
     EXCEPTIONS
       argument_not_found       = 1
       destination_not_found    = 2
       destination_no_authority = 3
       plugin_not_active        = 4
       internal_error           = 5
       OTHERS                   = 6 ).
    IF sy-subrc <> 0.
      RETURN. " TODO: Raise an exception
    ENDIF.

    rest_client = NEW cl_rest_http_client( http_client ).

    cl_http_utility=>set_request_uri( request = http_client->request
                                      uri     = uri ).

    DATA(request) = rest_client->if_rest_client~create_request_entity( ).

    request->set_content_type( iv_media_type = if_rest_media_type=>gc_appl_json ).

    rest_client->if_rest_client~set_request_header( iv_name  = 'auth-token'
                                                    iv_value = get_auth_token( ) ).

  ENDMETHOD.


  METHOD read_repository_objects.

    DATA:
      object_type_range TYPE RANGE OF zif_conflu_obj_documentation=>ts_filter-object_type,
      object_name_range TYPE RANGE OF zif_conflu_obj_documentation=>ts_filter-object_name.

    LOOP AT filters REFERENCE INTO DATA(filter) WHERE object_type IS NOT INITIAL.

      INSERT VALUE #( sign = 'I' option = 'EQ'
                      low  = filter->object_type ) INTO TABLE object_type_range.

      IF filter->object_name IS NOT INITIAL.
        INSERT VALUE #( sign = 'I' option = 'EQ'
                        low  = filter->object_name ) INTO TABLE object_name_range.
      ENDIF.

    ENDLOOP.

    SELECT *
      INTO TABLE @objects
      FROM tadir
      WHERE devclass = @package
        AND object   IN @object_type_range
        AND obj_name IN @object_name_range.

  ENDMETHOD.


  METHOD load_export_objects.

    DATA:
      export_object TYPE REF TO zif_conflu_obj.

    TRY.
        DATA(interface) = NEW cl_oo_interface( 'ZIF_CONFLU_OBJ' ).
      CATCH cx_class_not_existent.
        RETURN.
    ENDTRY.

    DATA(classes) = interface->get_implementing_classes( ).

    LOOP AT classes REFERENCE INTO DATA(class).

      CREATE OBJECT export_object TYPE (class->clsname).

      INSERT VALUE #( type   = export_object->get_type( )
                      object = export_object ) INTO TABLE exporters.

    ENDLOOP.

  ENDMETHOD.


  METHOD export_documentation.



  ENDMETHOD.


  METHOD deserialize_space_info.

    DATA:
      BEGIN OF space_info_schema,
        id   TYPE i,
        key  TYPE string,
        name TYPE string,
        type TYPE string,
        BEGIN OF _links,
          webui TYPE string,
          base  TYPE string,
        END OF _links,
      END OF space_info_schema.

    /ui2/cl_json=>deserialize( EXPORTING json = content
                               CHANGING  data = space_info_schema ).

    space_info = CORRESPONDING #( space_info_schema ).

    space_info-url = |{ space_info_schema-_links-base }{ space_info_schema-_links-webui }|.

  ENDMETHOD.


  METHOD deserialize_pages_info.

    TYPES:
      BEGIN OF lts_page_info,
        id     TYPE i,
        type   TYPE string,
        status TYPE string,
        title  TYPE string,
        BEGIN OF _links,
          webui TYPE string,
        END OF _links,
      END OF lts_page_info,
      ltt_page_info TYPE SORTED TABLE OF lts_page_info WITH UNIQUE KEY id,

      BEGIN OF lts_results,
        results TYPE ltt_page_info,
        BEGIN OF _links,
          base TYPE string,
        END OF _links,
      END OF lts_results.

    DATA:
      data TYPE lts_results.

    /ui2/cl_json=>deserialize( EXPORTING json = content
                               CHANGING  data = data ).

    LOOP AT data-results REFERENCE INTO DATA(result).

      INSERT VALUE #( id     = result->id
                      type   = result->type
                      status = result->status
                      title  = result->title
                      url    = |{ data-_links-base }{ result->_links-webui }| ) INTO TABLE pages_info.

    ENDLOOP.

  ENDMETHOD.


  METHOD search_page.

    DATA(uri_escaped) = escape( val = title format = cl_abap_format=>e_xss_url ).

    DATA(rest_client) = create_rest_client( |{ get_content_uri( ) }?spaceKey={ space_key }&title={ uri_escaped }| ).

    rest_client->if_rest_resource~get( ).

    DATA(info_json) = rest_client->if_rest_client~get_response_entity( )->get_string_data( ).

    DATA(pages_info) = deserialize_pages_info( info_json ).

    page_info = COND #( WHEN lines( pages_info ) > 0 THEN pages_info[ 1 ] ).

  ENDMETHOD.


  METHOD search_child_page.

    DATA(uri_escaped) = escape( val = title format = cl_abap_format=>e_xss_url ).

    DATA(rest_client) = create_rest_client( |{ get_page_childs_uri( parent ) }| ).

    rest_client->if_rest_resource~get( ).

    DATA(info_json) = rest_client->if_rest_client~get_response_entity( )->get_string_data( ).

    DATA(pages_info) = deserialize_pages_info( info_json ).

    IF wildcard IS INITIAL.
      page_info = COND #( WHEN line_exists( pages_info[ title = title ] ) THEN pages_info[ title = title ] ).
    ELSE.
    ENDIF.

  ENDMETHOD.


ENDCLASS.
