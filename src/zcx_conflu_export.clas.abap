CLASS zcx_conflu_export DEFINITION
  PUBLIC
  INHERITING FROM zcx_conflu
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !text1    TYPE string OPTIONAL
        !text2    TYPE string OPTIONAL
        !text3    TYPE string OPTIONAL
        !text4    TYPE string OPTIONAL
        !previous LIKE previous OPTIONAL .

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcx_conflu_export IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( textid   = textid
                        text1    = text1
                        text2    = text2
                        text3    = text3
                        text4    = text4
                        previous = previous ).

  ENDMETHOD.


ENDCLASS.
