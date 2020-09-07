"! <p class="shorttext synchronized" lang="en">Object Oriented Object</p>
CLASS zcl_conflu_obj_oo DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS get_type ABSTRACT
      RETURNING
        VALUE(object_type) TYPE trobjtype.

    METHODS get_documentation_levels FINAL
      RETURNING
        VALUE(levels) TYPE zif_conflu_obj=>tt_documentation_level.

    METHODS get_description FINAL
      IMPORTING
        object_name        TYPE sobj_name
        package            TYPE devclass
      RETURNING
        VALUE(description) TYPE string
      RAISING
        zcx_conflu_docu.

    METHODS read_documentation FINAL
      IMPORTING
        object_name          TYPE sobj_name
        package              TYPE devclass
      RETURNING
        VALUE(documentation) TYPE string
      RAISING
        zcx_conflu_docu.

    METHODS get_class_page_content
      RETURNING
        VALUE(content) TYPE string.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_conflu_obj_oo IMPLEMENTATION.


  METHOD get_documentation_levels.

    levels = VALUE #(
                ( level = 1 name = 'Source Code Library' )
                ( level = 2 name = SWITCH #( get_type( ) WHEN 'CLAS' THEN 'Classes'
                                                         WHEN 'INTF' THEN 'Interfaces' )
                  default_content = get_class_page_content( ) ) ).

  ENDMETHOD.


  METHOD get_description.

    DATA:
      class_key            TYPE seoclskey,
      class_properties     TYPE vseoclass,
      interface_properties TYPE vseointerf.

    class_key-clsname = object_name.

    CALL FUNCTION 'SEO_CLIF_GET'
      EXPORTING
        cifkey       = class_key
        version      = seoc_version_active
      IMPORTING
        class        = class_properties
        interface    = interface_properties
      EXCEPTIONS
        not_existing = 1
        deleted      = 2
        model_only   = 3
        OTHERS       = 4.
    IF sy-subrc = 1.
      RETURN.
    ELSEIF sy-subrc <> 0.
      zcx_conflu_docu=>raise_system( ).
    ENDIF.

    description = SWITCH #( get_type( ) WHEN 'CLAS' THEN class_properties-descript
                                        WHEN 'INTF' THEN interface_properties-descript ).

  ENDMETHOD.


  METHOD read_documentation.

    DATA(doc_export) = cl_sedi_abap_doc_export=>create_instance( ).

    DATA(doc_html) = doc_export->get_ei_of_program_as_html_page(
                              program_id       = VALUE #( name    = object_name
                                                          type    = get_type( )
                                                          package = package )
                              scope_visibility = if_sedi_abap_doc_export=>co_filter_scope-visibility_public_protected ).

    DATA(regex) = NEW cl_abap_regex( pattern = '<body[^>]*>(.*)</body>' ignore_case = abap_true ).

    DATA(matcher) = regex->create_matcher( text = doc_html ).

    DATA(matches) = matcher->find_all( ).

    IF matches IS INITIAL.
      RETURN.
    ENDIF.

    DATA(match) = matches[ 1 ].

    IF match-submatches IS INITIAL.
      RETURN.
    ENDIF.

    DATA(submatch) = match-submatches[ 1 ].

    documentation = substring( val = doc_html
                               off = submatch-offset
                               len = submatch-length ).

  ENDMETHOD.


  METHOD get_class_page_content.

    content =
     |<p>| &
*     |  <ac:structured-macro ac:name="detailssummary" ac:schema-version="2">| &
     |  <ac:structured-macro ac:name="detailssummary">| &
     |    <ac:parameter ac:name="firstcolumn">Class description</ac:parameter>| &
     |    <ac:parameter ac:name="headings">Package</ac:parameter>| &
     |    <ac:parameter ac:name="sortBy">Package</ac:parameter>| &
     |    <ac:parameter ac:name="id">repository</ac:parameter>| &
     |    <ac:parameter ac:name="cql">label = "{ to_lower( get_type( ) ) }" and space = currentSpace()</ac:parameter>| &
     |  </ac:structured-macro>| &
     |</p>|.

  ENDMETHOD.


ENDCLASS.
