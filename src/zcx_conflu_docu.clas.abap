"! <p class="shorttext synchronized" lang="en">Documentation exceptions</p>
CLASS zcx_conflu_docu DEFINITION
  PUBLIC
  INHERITING FROM zcx_conflu
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! <p class="shorttext synchronized" lang="en">Raise exception with system attribute message</p>
    "!
    "! @raising zcx_conflu_docu | <p class="shorttext synchronized" lang="en">Exception</p>
    CLASS-METHODS raise_system
      RAISING
        zcx_conflu_docu.

    "! <p class="shorttext synchronized" lang="en">CONSTRUCTOR</p>
    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !text1    TYPE string OPTIONAL
        !text2    TYPE string OPTIONAL
        !text3    TYPE string OPTIONAL
        !text4    TYPE string OPTIONAL
        !previous LIKE previous OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcx_conflu_docu IMPLEMENTATION.


  METHOD raise_system.

    RAISE EXCEPTION TYPE zcx_conflu_docu
      EXPORTING
        textid = VALUE scx_t100key( msgid = sy-msgid
                                    msgno = sy-msgno
                                    attr1 = 'TEXT1'
                                    attr2 = 'TEXT2'
                                    attr3 = 'TEXT3'
                                    attr4 = 'TEXT4' )
        text1  = CONV #( sy-msgv1 )
        text2  = CONV #( sy-msgv2 )
        text3  = CONV #( sy-msgv3 )
        text4  = CONV #( sy-msgv4 ).

  ENDMETHOD.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( textid   = textid
                        text1    = text1
                        text2    = text2
                        text3    = text3
                        text4    = text4
                        previous = previous ).

  ENDMETHOD.


ENDCLASS.
