CLASS lcl_ddl_source IMPLEMENTATION.


  METHOD constructor.

    TRY.
        cl_dd_ddl_handler_factory=>create( )->read(
          EXPORTING
            name         = ddlname
            get_state    = 'A'
          IMPORTING
            ddddlsrcv_wa = DATA(ls_source) ).
      CATCH cx_dd_ddl_read INTO DATA(lx_ddl_read).
        RAISE EXCEPTION TYPE zcx_conflu_docu
          EXPORTING
            previous = lx_ddl_read.
    ENDTRY.

    source = ls_source.

  ENDMETHOD.


  METHOD get_name.

    result = source-ddtext.

  ENDMETHOD.


  METHOD get_definition.



  ENDMETHOD.


ENDCLASS.
