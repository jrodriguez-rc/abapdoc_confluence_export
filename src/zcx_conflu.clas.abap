CLASS zcx_conflu DEFINITION
  PUBLIC
  INHERITING FROM zcx_static_exception
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    DATA:
      text1 TYPE string READ-ONLY,
      text2 TYPE string READ-ONLY,
      text3 TYPE string READ-ONLY,
      text4 TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !text1    TYPE string OPTIONAL
        !text2    TYPE string OPTIONAL
        !text3    TYPE string OPTIONAL
        !text4    TYPE string OPTIONAL
        !previous LIKE previous OPTIONAL .

  PROTECTED SECTION.
    TYPES:
      BEGIN OF ts_t100_message,
        key   TYPE scx_t100key,
        msgv1 TYPE symsgv,
        msgv2 TYPE symsgv,
        msgv3 TYPE symsgv,
        msgv4 TYPE symsgv,
      END OF ts_t100_message.

    CLASS-METHODS text_to_t100key
      IMPORTING
        text               TYPE csequence
      RETURNING
        VALUE(t100message) TYPE ts_t100_message.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcx_conflu IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    me->text1 = text1.
    me->text2 = text2.
    me->text3 = text3.
    me->text4 = text4.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

  ENDMETHOD.


  METHOD text_to_t100key.

    DATA:
      BEGIN OF message_variables,
        msgv1 TYPE symsgv,
        msgv2 TYPE symsgv,
        msgv3 TYPE symsgv,
        msgv4 TYPE symsgv,
      END OF message_variables.

    message_variables = text.

    t100message-key = VALUE scx_t100key( msgid = '00'
                                         msgno = '001'
                                         attr1 = 'TEXT1'
                                         attr2 = 'TEXT2'
                                         attr3 = 'TEXT3'
                                         attr4 = 'TEXT4' ).

    t100message-msgv1 = message_variables-msgv1.
    t100message-msgv2 = message_variables-msgv2.
    t100message-msgv3 = message_variables-msgv3.
    t100message-msgv4 = message_variables-msgv4.

  ENDMETHOD.


ENDCLASS.
