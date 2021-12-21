"! <p class="shorttext synchronized" lang="en">Export Objects documentation</p>
CLASS zcl_conflu_obj_documentation DEFINITION
  PUBLIC
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

    "! <p class="shorttext synchronized" lang="en">CONSTRUCTOR</p>
    "!
    "! @parameter space_key | <p class="shorttext synchronized" lang="en">Confluence space key</p>
    "! @parameter package | <p class="shorttext synchronized" lang="en">Package</p>
    "! @raising zcx_conflu | <p class="shorttext synchronized" lang="en">Confluence exception</p>
    METHODS constructor
      IMPORTING
        space_key TYPE string
        package   TYPE devclass
      RAISING
        zcx_conflu.

  PROTECTED SECTION.
    TYPES:
      BEGIN OF ts_status_response,
        status_code TYPE i,
        BEGIN OF data,
          authorized                TYPE abap_bool,
          valid                     TYPE abap_bool,
          allowed_in_read_only_mode TYPE abap_bool,
          successful                TYPE abap_bool,
        END OF data,
        message     TYPE string,
        reason      TYPE string,
      END OF ts_status_response.

    METHODS get_documentation_object FINAL
      IMPORTING
        object_type   TYPE trobjtype
      RETURNING
        VALUE(object) TYPE REF TO zif_conflu_obj
      RAISING
        cx_sy_itab_line_not_found.

    METHODS get_space_uri
      RETURNING
        VALUE(uri) TYPE string.

    METHODS get_content_uri
      RETURNING
        VALUE(uri) TYPE string.

    METHODS get_labels_uri
      IMPORTING
        page_id    TYPE i
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

    METHODS deserialize_page_info
      IMPORTING
        content          TYPE string
      RETURNING
        VALUE(page_info) TYPE zif_conflu_obj_documentation=>ts_page_info.

    METHODS deserialize_pages_info
      IMPORTING
        content           TYPE string
      RETURNING
        VALUE(pages_info) TYPE zif_conflu_obj_documentation=>tt_page_info.

    METHODS deserialize_labels
      IMPORTING
        content       TYPE string
      RETURNING
        VALUE(labels) TYPE zif_conflu_obj_documentation=>tt_labels.

    METHODS deserialize_status_response
      IMPORTING
        content         TYPE string
      RETURNING
        VALUE(response) TYPE ts_status_response.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ts_exporter,
        type   TYPE trobjtype,
        object TYPE REF TO zif_conflu_obj,
      END OF ts_exporter,
      tt_exporter TYPE SORTED TABLE OF ts_exporter WITH UNIQUE KEY type,

      BEGIN OF ts_doc_objects,
        object_type TYPE trobjtype,
        object_name TYPE sobj_name,
        package     TYPE devclass,
        content     TYPE string,
      END OF ts_doc_objects,
      tt_doc_objects TYPE HASHED TABLE OF ts_doc_objects WITH UNIQUE KEY object_type object_name,

      tt_tadir       TYPE HASHED TABLE OF tadir WITH UNIQUE KEY pgmid object obj_name.

    DATA:
      space_key             TYPE string,
      package               TYPE devclass,
      documentation_objects TYPE tt_exporter.

    METHODS create_http_client
      RETURNING
        VALUE(http_client) TYPE REF TO if_http_client
      RAISING
        zcx_conflu_rest.

    METHODS create_rest_client
      IMPORTING
        uri                TYPE string
        data               TYPE string OPTIONAL
        api_method         TYPE string DEFAULT zif_conflu_constants=>api_method-get
      RETURNING
        VALUE(rest_client) TYPE REF TO cl_rest_http_client
      RAISING
        zcx_conflu_rest.

    METHODS read_repository_objects
      IMPORTING
        filters        TYPE zif_conflu_obj_documentation=>tt_filter
      RETURNING
        VALUE(objects) TYPE tt_tadir.

    METHODS load_export_objects
      RAISING
        zcx_conflu_export.

    METHODS export_doc_object
      IMPORTING
        doc_object TYPE ts_doc_objects
      RAISING
        zcx_conflu_rest
        zcx_conflu_docu
        zcx_conflu_export.

    METHODS generate_json_doc_object
      IMPORTING
        doc_object    TYPE ts_doc_objects
        antecesor     TYPE i OPTIONAL
      RETURNING
        VALUE(result) TYPE string
      RAISING
        zcx_conflu_rest
        zcx_conflu_docu
        zcx_conflu_export.

    METHODS search_page
      IMPORTING
        title            TYPE string
      RETURNING
        VALUE(page_info) TYPE zif_conflu_obj_documentation=>ts_page_info
      RAISING
        zcx_conflu_rest.

    METHODS search_child_page
      IMPORTING
        parent           TYPE i
        title            TYPE string
        wildcard         TYPE abap_bool OPTIONAL
      RETURNING
        VALUE(page_info) TYPE zif_conflu_obj_documentation=>ts_page_info
      RAISING
        zcx_conflu_rest.

    METHODS create_page
      IMPORTING
        title            TYPE string
        parent           TYPE i
        body             TYPE string
        doc_object       TYPE ts_doc_objects OPTIONAL
        labels           TYPE zif_conflu_obj_documentation=>tt_labels OPTIONAL
      RETURNING
        VALUE(page_info) TYPE zif_conflu_obj_documentation=>ts_page_info
      RAISING
        zcx_conflu_rest
        zcx_conflu_export.

    METHODS generate_json
      IMPORTING
        title         TYPE string
        body          TYPE string
        doc_object    TYPE ts_doc_objects OPTIONAL
        antecesor     TYPE i OPTIONAL
      RETURNING
        VALUE(result) TYPE string
      RAISING
        zcx_conflu_rest
        zcx_conflu_export.

    METHODS update_page
      IMPORTING
        page_id          TYPE i OPTIONAL
        version          TYPE i OPTIONAL
        title            TYPE string
        parent           TYPE i
        body             TYPE string
        doc_object       TYPE ts_doc_objects OPTIONAL
        labels           TYPE zif_conflu_obj_documentation=>tt_labels OPTIONAL
      RETURNING
        VALUE(page_info) TYPE zif_conflu_obj_documentation=>ts_page_info
      RAISING
        zcx_conflu_rest
        zcx_conflu_export.

    METHODS get_page_labels
      IMPORTING
        page_id       TYPE i OPTIONAL
      RETURNING
        VALUE(labels) TYPE zif_conflu_obj_documentation=>tt_labels
      RAISING
        zcx_conflu_rest
        zcx_conflu_export.

    METHODS set_page_labels
      IMPORTING
        page_id TYPE i OPTIONAL
        labels  TYPE zif_conflu_obj_documentation=>tt_labels
      RAISING
        zcx_conflu_rest
        zcx_conflu_export.

    METHODS add_page_labels
      IMPORTING
        page_id TYPE i
        labels  TYPE zif_conflu_obj_documentation=>tt_labels
      RAISING
        zcx_conflu_rest
        zcx_conflu_export.

    METHODS delete_page_labels
      IMPORTING
        page_id TYPE i
        labels  TYPE zif_conflu_obj_documentation=>tt_labels
      RAISING
        zcx_conflu_rest
        zcx_conflu_export.
    METHODS get_object_properties_xml
      IMPORTING
        doc_object            TYPE zcl_conflu_obj_documentation=>ts_doc_objects
      RETURNING
        VALUE(properties_xml) TYPE string.

ENDCLASS.



CLASS zcl_conflu_obj_documentation IMPLEMENTATION.


  METHOD create.

    TRY.
        DATA(main_class) = NEW cl_oo_class( 'ZCL_CONFLU_OBJ_DOCUMENTATION' ).
      CATCH cx_class_not_existent INTO DATA(class_exception).
        RAISE EXCEPTION TYPE zcx_conflu
          EXPORTING
            previous = class_exception.
    ENDTRY.

    DATA(subclasses) = main_class->get_subclasses( ).

    IF subclasses IS INITIAL.
      object_documentation = NEW zcl_conflu_obj_documentation( space_key = space_key package = package ).
    ELSE.
      DATA(subclass_name) = subclasses[ 1 ]-clsname.
      CREATE OBJECT object_documentation TYPE (subclass_name)
        EXPORTING
          space_key = space_key
          package   = package.
    ENDIF.

  ENDMETHOD.

  METHOD constructor.

    me->space_key = space_key.
    me->package   = package.

    load_export_objects( ).

  ENDMETHOD.


  METHOD zif_conflu_obj_documentation~get_space_info.

    DATA(rest_client) = create_rest_client( get_space_uri( ) ).

    DATA(info_json) = rest_client->if_rest_client~get_response_entity( )->get_string_data( ).

    information = deserialize_space_info( info_json ).

  ENDMETHOD.


  METHOD zif_conflu_obj_documentation~get_page_info.

    TRY.
        DATA(documentation_object) = get_documentation_object( CONV #( object_type ) ).
      CATCH cx_sy_itab_line_not_found.
        RETURN. " TODO: Raise an exception - Object not supported
    ENDTRY.

    DATA(levels) = zif_conflu_obj_documentation~get_documentation_levels( object_type ).

    IF line_exists( levels[ page_info-id = 0 ] ).
      RETURN. " TODO: Raise an exception - Level path not found
    ENDIF.

    information =
        COND #( WHEN levels IS INITIAL
                    THEN search_page( object_name )
                    ELSE search_child_page( parent   = levels[ lines( levels ) ]-page_info-id
                                            title    = object_name
                                            wildcard = abap_true ) ).

  ENDMETHOD.


  METHOD zif_conflu_obj_documentation~get_documentation_levels.

    DATA:
      previous_level TYPE zif_conflu_obj_documentation=>ts_documentation_level.

    TRY.
        DATA(object_documentation) = get_documentation_object( CONV #( object_type ) ).
      CATCH cx_sy_itab_line_not_found.
        RETURN. " TODO: Raise an exception - Object not supported
    ENDTRY.

    DATA(levels_base) = object_documentation->get_documentation_levels( ).

    levels = CORRESPONDING #( levels_base ).

    LOOP AT levels REFERENCE INTO DATA(level).

      level->page_info = COND #( WHEN previous_level IS INITIAL
                                THEN search_page( level->name )
                                ELSE search_child_page( parent = previous_level-page_info-id title = level->name ) ).

      IF level->page_info IS INITIAL.
        EXIT.
      ENDIF.

      previous_level = level->*.

    ENDLOOP.

  ENDMETHOD.


  METHOD zif_conflu_obj_documentation~export.

    DATA(doc_objects) = VALUE tt_doc_objects( ).

    LOOP AT read_repository_objects( filter ) REFERENCE INTO DATA(object).

      TRY.
          DATA(object_documentation) = get_documentation_object( object->object ).
        CATCH cx_sy_itab_line_not_found.
          CONTINUE.
      ENDTRY.

      INSERT VALUE ts_doc_objects(
          object_type = object->object
          object_name = object->obj_name
          package     = object->devclass
          content     = object_documentation->read_documentation( object_name = object->obj_name
                                                                  package     = object->devclass )
        ) INTO TABLE doc_objects.

    ENDLOOP.


    LOOP AT doc_objects REFERENCE INTO DATA(doc_object).
      export_doc_object( doc_object->* ).
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_conflu_obj_documentation~generate_json.

    DATA(doc_objects) = VALUE tt_doc_objects( ).

    LOOP AT read_repository_objects( filter ) REFERENCE INTO DATA(object).

      TRY.
          DATA(object_documentation) = get_documentation_object( object->object ).
        CATCH cx_sy_itab_line_not_found.
          CONTINUE.
      ENDTRY.

      INSERT VALUE ts_doc_objects(
          object_type = object->object
          object_name = object->obj_name
          package     = object->devclass
          content     = object_documentation->read_documentation( object_name = object->obj_name
                                                                  package     = object->devclass )
        ) INTO TABLE doc_objects.

    ENDLOOP.

    result =
        VALUE #(
            FOR doc_object IN doc_objects
            ( object_type = doc_object-object_type
              object_name = doc_object-object_name
              package     = doc_object-package
              content     = generate_json_doc_object( doc_object = doc_object antecesor = antecesor ) ) ).

  ENDMETHOD.


  METHOD get_documentation_object.

    object = documentation_objects[ type = object_type ]-object.

  ENDMETHOD.


  METHOD get_space_uri.

    uri = |{ zif_conflu_constants=>api_resources-spaces }/{ space_key }|.

  ENDMETHOD.


  METHOD get_content_uri.

    uri = |{ zif_conflu_constants=>api_resources-content }|.

  ENDMETHOD.


  METHOD get_labels_uri.

    uri = replace( val = zif_conflu_constants=>api_resources-labels sub = |<!PAGE!>| with = |{ page_id ZERO = NO }| ).

  ENDMETHOD.


  METHOD get_page_childs_uri.

    uri = |{ get_content_uri( ) }/{ parent ZERO = NO }/child/page|.

  ENDMETHOD.


  METHOD create_http_client.

    cl_http_client=>create_by_destination(
     EXPORTING
       destination              = zif_conflu_constants=>rfc_destination
     IMPORTING
       client                   = http_client
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


  METHOD create_rest_client.

    DATA(http_client) = create_http_client( ).

    rest_client = NEW cl_rest_http_client( http_client ).

    cl_http_utility=>set_request_uri( request = http_client->request
                                      uri     = uri ).

    DATA(request) = rest_client->if_rest_client~create_request_entity( ).

    request->set_content_type( if_rest_media_type=>gc_appl_json ).

    request->set_header_field( iv_name  = 'Content-Type'
                               iv_value = if_rest_media_type=>gc_appl_json ).

    request->set_string_data( data ).

    DATA(header_fields) = request->get_header_fields( ).

    CASE api_method.
      WHEN zif_conflu_constants=>api_method-get.
        rest_client->if_rest_client~get( ).

      WHEN zif_conflu_constants=>api_method-post.
        rest_client->if_rest_client~post( request ).

      WHEN zif_conflu_constants=>api_method-put.
        rest_client->if_rest_client~put( request ).

      WHEN zif_conflu_constants=>api_method-delete.
        rest_client->if_rest_client~delete( ).

    ENDCASE.

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
                      object = export_object ) INTO TABLE documentation_objects.

    ENDLOOP.

  ENDMETHOD.


  METHOD export_doc_object.

    DATA(levels) = zif_conflu_obj_documentation~get_documentation_levels( CONV #( doc_object-object_type ) ).

    LOOP AT levels REFERENCE INTO DATA(level) WHERE page_info-id = 0.
      DATA(parent_page) = create_page( title  = level->name
                                       parent = COND #( WHEN level->level > 1
                                                            THEN levels[ level = level->level - 1 ]-page_info-id )
                                       body   = level->default_content ).
    ENDLOOP.

    DATA(documentation_object) = get_documentation_object( doc_object-object_type ).

    DATA(object_description) = documentation_object->get_description( object_name = doc_object-object_name
                                                                      package     = doc_object-package ).

    DATA(page_info) = zif_conflu_obj_documentation~get_page_info(
        object_type = CONV #( doc_object-object_type )
        object_name = CONV #( doc_object-object_name ) ).

    IF page_info IS INITIAL.
      create_page( title      = |{ doc_object-object_name } - { object_description }|
                   parent     = COND #( WHEN parent_page-id IS NOT INITIAL THEN parent_page-id
                                                                           ELSE levels[ lines( levels ) ]-page_info-id )
                   body       = doc_object-content
                   doc_object = doc_object
                   labels     = VALUE #( ( name = doc_object-package )
                                         ( name = doc_object-object_type ) ) ).
    ELSE.
      update_page( page_id    = page_info-id
                   version    = page_info-version
                   title      = |{ doc_object-object_name } - { object_description }|
                   parent     = COND #( WHEN parent_page-id IS NOT INITIAL THEN parent_page-id
                                                                           ELSE levels[ lines( levels ) ]-page_info-id )
                   body       = doc_object-content
                   doc_object = doc_object
                   labels     = VALUE #( ( name = doc_object-package )
                                         ( name = doc_object-object_type ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD generate_json_doc_object.

    DATA(documentation_object) = get_documentation_object( doc_object-object_type ).

    DATA(object_description) =
        documentation_object->get_description(
            object_name = doc_object-object_name
            package     = doc_object-package ).

    result =
        generate_json(
            title      = |{ doc_object-object_name } - { object_description }|
            body       = doc_object-content
            doc_object = doc_object
            antecesor  = antecesor ).

  ENDMETHOD.


  METHOD generate_json.

    TYPES:
      BEGIN OF lts_antecesors,
        id TYPE i,
      END OF lts_antecesors,
      ltt_antecesors TYPE STANDARD TABLE OF lts_antecesors WITH DEFAULT KEY.

    DATA:
      BEGIN OF content,
        BEGIN OF version,
          number TYPE i,
        END OF version,
        id        TYPE i,
        type      TYPE string,
        title     TYPE string,
        ancestors TYPE ltt_antecesors,
        BEGIN OF space,
          key TYPE string,
        END OF space,
        BEGIN OF body,
          BEGIN OF storage,
            value          TYPE string,
            representation TYPE string,
          END OF storage,
        END OF body,
      END OF content.

    DATA(properties) = COND #( WHEN doc_object IS NOT INITIAL THEN get_object_properties_xml( doc_object ) ).

    content-version-number = 0.

    content-id        = 0.
    content-type      = zif_conflu_constants=>content_type-page.
    content-title     = title.
    content-ancestors = COND #( WHEN antecesor > 0 THEN VALUE #( ( id = antecesor ) ) ).
    content-space-key = space_key.

    content-body-storage-value = |{ properties }{ body }|.
    content-body-storage-representation = |storage|.

    result = /ui2/cl_json=>serialize( data        = content
                                      pretty_name = /ui2/cl_json=>pretty_mode-low_case ).

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


  METHOD deserialize_page_info.

    TYPES:
      BEGIN OF lts_page_info,
        id     TYPE i,
        type   TYPE string,
        status TYPE string,
        title  TYPE string,
        BEGIN OF version,
          number TYPE i,
        END OF version,
        BEGIN OF _links,
          webui TYPE string,
          base  TYPE string,
        END OF _links,
      END OF lts_page_info.

    DATA:
      data TYPE lts_page_info.

    /ui2/cl_json=>deserialize( EXPORTING json = content
                               CHANGING  data = data ).

    page_info-id      = data-id.
    page_info-type    = data-type.
    page_info-status  = data-status.
    page_info-title   = data-title.
    page_info-version = data-version-number.
    page_info-url     = |{ data-_links-base }{ data-_links-webui }|.

  ENDMETHOD.


  METHOD deserialize_pages_info.

    TYPES:
      BEGIN OF lts_page_info,
        id     TYPE i,
        type   TYPE string,
        status TYPE string,
        title  TYPE string,
        BEGIN OF version,
          number TYPE i,
        END OF version,
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

      INSERT VALUE #( id      = result->id
                      type    = result->type
                      status  = result->status
                      title   = result->title
                      version = result->version-number
                      url     = |{ data-_links-base }{ result->_links-webui }| ) INTO TABLE pages_info.

    ENDLOOP.

  ENDMETHOD.


  METHOD deserialize_labels.

    TYPES:
      BEGIN OF lts_result,
        prefix TYPE string,
        name   TYPE string,
        id     TYPE i,
      END OF lts_result,
      ltt_result TYPE STANDARD TABLE OF lts_result WITH DEFAULT KEY.

    DATA:
      BEGIN OF data,
        results TYPE ltt_result,
        start   TYPE i,
        limit   TYPE i,
        size    TYPE i,
        BEGIN OF _links,
          self    TYPE string,
          base    TYPE string,
          context TYPE string,
        END OF _links,
      END OF data.

    /ui2/cl_json=>deserialize( EXPORTING json = content
                               CHANGING  data = data ).

    labels = CORRESPONDING #( data-results MAPPING name = name ).

  ENDMETHOD.


  METHOD deserialize_status_response.

    /ui2/cl_json=>deserialize( EXPORTING json = content
                               CHANGING  data = response ).

  ENDMETHOD.


  METHOD search_page.

    DATA(uri_escaped) = escape( val = title format = cl_abap_format=>e_xss_url ).

    DATA(rest_client) = create_rest_client( |{ get_content_uri( ) }?spaceKey={ space_key }&title={ uri_escaped }| ).

    DATA(info_json) = rest_client->if_rest_client~get_response_entity( )->get_string_data( ).

    DATA(pages_info) = deserialize_pages_info( info_json ).

    page_info = COND #( WHEN lines( pages_info ) > 0 THEN pages_info[ 1 ] ).

  ENDMETHOD.


  METHOD search_child_page.

    DATA(uri_escaped) = escape( val = title format = cl_abap_format=>e_xss_url ).

    DATA(rest_client) = create_rest_client( |{ get_page_childs_uri( parent ) }?expand=version| ).

    DATA(info_json) = rest_client->if_rest_client~get_response_entity( )->get_string_data( ).

    DATA(pages_info) = deserialize_pages_info( info_json ).

    IF wildcard IS INITIAL.
      page_info = COND #( WHEN line_exists( pages_info[ title = title ] ) THEN pages_info[ title = title ] ).
    ELSE.
      LOOP AT pages_info REFERENCE INTO DATA(page_info_wc) WHERE title CP |{ title }*|.
        page_info = page_info_wc->*.
        EXIT.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD create_page.

    page_info = COND #( WHEN labels IS SUPPLIED
                            THEN update_page( title      = title
                                              parent     = parent
                                              body       = body
                                              doc_object = doc_object
                                              labels     = labels )
                            ELSE update_page( title      = title
                                              parent     = parent
                                              body       = body
                                              doc_object = doc_object ) ).

  ENDMETHOD.


  METHOD update_page.

    TYPES:
      BEGIN OF lts_antecesors,
        id TYPE i,
      END OF lts_antecesors,
      ltt_antecesors TYPE STANDARD TABLE OF lts_antecesors WITH DEFAULT KEY.

    DATA:
      BEGIN OF content,
        BEGIN OF version,
          number TYPE i,
        END OF version,
        id        TYPE i,
        type      TYPE string,
        title     TYPE string,
        ancestors TYPE ltt_antecesors,
        BEGIN OF space,
          key TYPE string,
        END OF space,
        BEGIN OF body,
          BEGIN OF storage,
            value          TYPE string,
            representation TYPE string,
          END OF storage,
        END OF body,
      END OF content.

    DATA(properties) = COND #( WHEN doc_object IS NOT INITIAL THEN get_object_properties_xml( doc_object ) ).

    content-version-number = COND #( WHEN version IS NOT INITIAL THEN version + 1 ).

    content-id        = page_id.
    content-type      = zif_conflu_constants=>content_type-page.
    content-title     = title.
    content-ancestors = COND #( WHEN parent <> 0 THEN VALUE #( ( id = parent ) ) ).
    content-space-key = space_key.

    content-body-storage-value = |{ properties }{ body }|.
    content-body-storage-representation = |storage|.

    DATA(json) = /ui2/cl_json=>serialize( data        = content
                                          pretty_name = /ui2/cl_json=>pretty_mode-low_case ).

    DATA(rest_client) = create_rest_client(
                                uri        = COND #( WHEN page_id IS INITIAL
                                                         THEN |{ get_content_uri( ) }|
                                                         ELSE |{ get_content_uri( ) }/{ page_id ZERO = NO }| )
                                data       = json
                                api_method = COND #( WHEN page_id IS INITIAL
                                                         THEN zif_conflu_constants=>api_method-post
                                                         ELSE zif_conflu_constants=>api_method-put ) ).

    DATA(rest_response) = rest_client->if_rest_client~get_response_entity( ).

    DATA(http_status) = rest_response->get_header_field( '~status_code' ).
    DATA(response) = rest_response->get_string_data( ).

    IF http_status BETWEEN '200' AND '299'.
      page_info = deserialize_page_info( response ).
    ELSE.
      DATA(status_response) = deserialize_status_response( response ).
      zcx_conflu_rest=>raise_text( COND #( WHEN status_response-message IS NOT INITIAL THEN status_response-message
                                                                                       ELSE status_response-reason ) ).
    ENDIF.

    IF labels IS SUPPLIED.
      set_page_labels( page_id = page_info-id
                       labels  = labels ).
    ENDIF.

  ENDMETHOD.


  METHOD get_page_labels.

    DATA(rest_client) = create_rest_client( |{ get_labels_uri( page_id ) }| ).

    DATA(labels_json) = rest_client->if_rest_client~get_response_entity( )->get_string_data( ).

    labels = deserialize_labels( labels_json ).

  ENDMETHOD.


  METHOD set_page_labels.

    DATA:
      labels_to_create TYPE zif_conflu_obj_documentation=>tt_labels,
      labels_to_delete TYPE zif_conflu_obj_documentation=>tt_labels.

    DATA(labels_assigned) = get_page_labels( page_id ).

    LOOP AT labels REFERENCE INTO DATA(label).

      IF line_exists( labels_assigned[ name = label->name ] ).
        CONTINUE.
      ENDIF.

      INSERT label->* INTO TABLE labels_to_create.

    ENDLOOP.

    LOOP AT labels_assigned REFERENCE INTO label.

      IF line_exists( labels[ name = label->name ] ).
        CONTINUE.
      ENDIF.

      INSERT label->* INTO TABLE labels_to_delete.

    ENDLOOP.

    delete_page_labels( page_id = page_id labels = labels_to_delete ).
    add_page_labels( page_id = page_id labels = labels_to_create ).

  ENDMETHOD.


  METHOD add_page_labels.

    TYPES:
      BEGIN OF lts_labels,
        prefix TYPE string,
        name   TYPE string,
      END OF lts_labels,
      ltt_labels TYPE STANDARD TABLE OF lts_labels WITH DEFAULT KEY.

    IF labels IS INITIAL.
      RETURN.
    ENDIF.

    DATA(labels_to_create) = CORRESPONDING ltt_labels( labels MAPPING name = name ).

    LOOP AT labels_to_create REFERENCE INTO DATA(label).
      label->prefix = |global|.
    ENDLOOP.

    DATA(rest_client) = create_rest_client( uri        = |{ get_labels_uri( page_id ) }|
                                            data       = /ui2/cl_json=>serialize(
                                                                    data = labels_to_create
                                                                    pretty_name = /ui2/cl_json=>pretty_mode-low_case )
                                            api_method = zif_conflu_constants=>api_method-post ).

    rest_client->if_rest_client~get_response_entity( )->get_string_data( ).

  ENDMETHOD.


  METHOD delete_page_labels.

    LOOP AT labels REFERENCE INTO DATA(label).

      DATA(rest_client) = create_rest_client( uri        = |{ get_labels_uri( page_id ) }/{ label->name }|
                                              api_method = zif_conflu_constants=>api_method-delete ).

      rest_client->if_rest_client~get_response_entity( )->get_string_data( ).

    ENDLOOP.

  ENDMETHOD.


  METHOD get_object_properties_xml.

    DATA:
      xml TYPE string.

    CALL TRANSFORMATION zconflu_prop_table
      SOURCE repository = doc_object
      RESULT XML xml.

    DATA(regex) = NEW cl_abap_regex( pattern = '<html[^>]*>(.*)</html>' ignore_case = abap_true ).

    DATA(matcher) = regex->create_matcher( text = xml ).

    DATA(matches) = matcher->find_all( ).

    IF matches IS INITIAL.
      RETURN.
    ENDIF.

    DATA(match) = matches[ 1 ].

    IF match-submatches IS INITIAL.
      RETURN.
    ENDIF.

    DATA(submatch) = match-submatches[ 1 ].

    properties_xml = substring( val = xml
                                off = submatch-offset
                                len = submatch-length ).

  ENDMETHOD.


ENDCLASS.
