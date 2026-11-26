CLASS zcl_chm_eml_demo DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_eml_demo IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA chaves   TYPE TABLE FOR READ IMPORT ZR_Chamado.
    DATA chamados TYPE TABLE FOR READ RESULT ZR_Chamado.
    DATA novos    TYPE TABLE FOR CREATE ZR_Chamado.
    DATA mudancas TYPE TABLE FOR UPDATE ZR_Chamado.

    SELECT ChamadoUUID FROM ZR_Chamado
      WHERE Status = 'A'
      INTO TABLE @DATA(abertos).

    READ ENTITIES OF ZR_Chamado
      ENTITY Chamado
        FIELDS ( ChamadoID Titulo )
        WITH CORRESPONDING #( abertos )
      RESULT chamados
      FAILED DATA(failed)
      REPORTED DATA(reported).

    mudancas = VALUE #( ( %tky                = chamados[ 1 ]-%tky
                          Prioridade          = 'A'
                          %control-Prioridade = if_abap_behv=>mk-on ) ).

    DATA(m) = mudancas[ 1 ].
    out->write( |Rascunho   { m-%tky-%is_draft }| ).
    out->write( |Prioridade { m-%control-Prioridade }| ).
    out->write( |Titulo     { m-%control-Titulo }| ).

    LOOP AT chamados INTO DATA(chamado).
      out->write( |{ chamado-ChamadoID } - { chamado-Titulo }| ).
    ENDLOOP.

    READ ENTITIES OF ZR_Chamado
      ENTITY Chamado BY \_Apontamentos
        ALL FIELDS
        WITH CORRESPONDING #( abertos )
      RESULT DATA(apontamentos).

    LOOP AT apontamentos INTO DATA(apont).
      out->write( |{ apont-DataApont DATE = ISO } { apont-Horas } { apont-Descricao }| ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
