CLASS zcl_chm_buffer DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS incluir IMPORTING chamado TYPE zchm_chamado.
    CLASS-METHODS alterar IMPORTING chamado TYPE zchm_chamado.
    CLASS-METHODS excluir IMPORTING chamado_id TYPE zchm_chamado-chamado_id.

    CLASS-METHODS ler
      IMPORTING chamado_id    TYPE zchm_chamado-chamado_id
      RETURNING VALUE(result) TYPE zchm_chamado.

    CLASS-METHODS proximo_id
      RETURNING VALUE(result) TYPE zchm_chamado-chamado_id.

    CLASS-METHODS gravar.
    CLASS-METHODS limpar.

  PRIVATE SECTION.
    CLASS-DATA novos     TYPE zcl_chm_log_legado=>tt_chamado.
    CLASS-DATA alterados TYPE zcl_chm_log_legado=>tt_chamado.
    CLASS-DATA excluidos TYPE zcl_chm_log_legado=>tt_chamado.
ENDCLASS.

CLASS zcl_chm_buffer IMPLEMENTATION.

  METHOD incluir.
    APPEND chamado TO novos.
  ENDMETHOD.

  METHOD alterar.
    DATA(linha) = chamado.

    linha-last_changed_by = sy-uname.
    GET TIME STAMP FIELD linha-last_changed_at.
    linha-local_last_changed_at = linha-last_changed_at.

    " criado nesta mesma transação: continua sendo um chamado novo, com os dados mais recentes
    ASSIGN novos[ chamado_id = linha-chamado_id ] TO FIELD-SYMBOL(<novo>).
    IF sy-subrc = 0.
      <novo> = linha.
      RETURN.
    ENDIF.

    " já existe no banco: uma linha por chamado na tabela de alterados
    ASSIGN alterados[ chamado_id = linha-chamado_id ] TO FIELD-SYMBOL(<alterado>).
    IF sy-subrc = 0.
      <alterado> = linha.
    ELSE.
      APPEND linha TO alterados.
    ENDIF.
  ENDMETHOD.

  METHOD excluir.
    " a leitura traz o chamado_uuid, que a classe legada exige para excluir
    DATA(chamado) = ler( chamado_id ).
    CHECK chamado IS NOT INITIAL.

    " criado e excluído na mesma transação: nunca chegou ao banco, basta esquecer
    IF line_exists( novos[ chamado_id = chamado_id ] ).
      DELETE novos WHERE chamado_id = chamado_id.
      RETURN.
    ENDIF.

    DELETE alterados WHERE chamado_id = chamado_id.
    APPEND chamado TO excluidos.
  ENDMETHOD.

  METHOD ler.
    IF line_exists( excluidos[ chamado_id = chamado_id ] ).
      RETURN.
    ENDIF.

    result = VALUE #( alterados[ chamado_id = chamado_id ]
               DEFAULT VALUE #( novos[ chamado_id = chamado_id ] OPTIONAL ) ).

    IF result IS INITIAL.
      SELECT SINGLE * FROM zchm_chamado
        WHERE chamado_id = @chamado_id INTO @result.
    ENDIF.
  ENDMETHOD.

  METHOD proximo_id.
    SELECT SINGLE FROM zchm_chamado
      FIELDS MAX( chamado_id )
      INTO @result.

    LOOP AT novos INTO DATA(novo) WHERE chamado_id > result.
      result = novo-chamado_id.
    ENDLOOP.

    result += 1.
  ENDMETHOD.

  METHOD gravar.
    zcl_chm_log_legado=>gravar( chamados = novos     operacao = 'C' ).
    zcl_chm_log_legado=>gravar( chamados = alterados operacao = 'U' ).

    LOOP AT excluidos INTO DATA(excluido).
      zcl_chm_log_legado=>excluir( excluido-chamado_uuid ).
    ENDLOOP.
  ENDMETHOD.

  METHOD limpar.
    CLEAR: novos, alterados, excluidos.
  ENDMETHOD.

ENDCLASS.
