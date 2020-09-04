CLASS zcl_conflu_obj_clas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_conflu_obj.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_conflu_obj_clas IMPLEMENTATION.


  METHOD zif_conflu_obj~get_type.

    object_type = 'CLAS'.

  ENDMETHOD.


  METHOD zif_conflu_obj~get_documentation_levels.

    levels = VALUE #( ( level = 1 name = 'Source Code Library' )
                      ( level = 2 name = 'Classes' ) ).

  ENDMETHOD.


  METHOD zif_conflu_obj~get_description.

    DATA:
      class_key        TYPE seoclskey,
      class_properties TYPE vseoclass.

    class_key-clsname = object_name.

    CALL FUNCTION 'SEO_CLIF_GET'
      EXPORTING
        cifkey       = class_key
        version      = seoc_version_active
      IMPORTING
        class        = class_properties
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

    description = class_properties-descript.

  ENDMETHOD.


  METHOD zif_conflu_obj~read_documentation.

    DATA(doc_export) = cl_sedi_abap_doc_export=>create_instance( ).

    DATA(doc_html) = doc_export->get_ei_of_program_as_html_page(
                              program_id       = VALUE #( name    = object_name
                                                          type    = zif_conflu_obj~get_type( )
                                                          package = package )
                              scope_visibility = if_sedi_abap_doc_export=>co_filter_scope-visibility_public_protected ).

    DATA(lo_regex) = NEW cl_abap_regex( pattern     = '<body[^>]*>(.*)</body>'
                                        ignore_case = abap_true ).

    DATA(lo_matcher) = lo_regex->create_matcher( text = doc_html ).

    DATA(lt_matches) = lo_matcher->find_all( ).

    LOOP AT lt_matches INTO DATA(ls_match).
      LOOP AT ls_match-submatches INTO DATA(ls_submatch).
        documentation = substring( val = doc_html
                                   off = ls_submatch-offset
                                   len = ls_submatch-length ).
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


ENDCLASS.
