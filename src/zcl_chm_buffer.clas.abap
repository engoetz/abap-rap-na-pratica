CLASS zcl_chm_buffer DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS incluir IMPORTING chamado TYPE zchm_chamado.
    CLASS-METHODS alterar IMPORTING chamado TYPE zchm_chamado.

    CLASS-METHODS excluir
      IMPORTING chamado_id TYPE zchm_chamado-chamado_id
                pid        TYPE abp_behv_pid OPTIONAL.

    CLASS-METHODS ler
      IMPORTING chamado_id    TYPE zchm_chamado-chamado_id
                pid           TYPE abp_behv_pid OPTIONAL
      RETURNING VALUE(result) TYPE zchm_chamado.

    CLASS-METHODS proximo_id
      RETURNING VALUE(result) TYPE zchm_chamado-chamado_id.

    CLASS-METHODS novo_uuid
      RETURNING VALUE(result) TYPE zchm_chamado-chamado_uuid.

    CLASS-METHODS numerar
      RETURNING VALUE(result) TYPE zcl_chm_log_legado=>tt_chamado.

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
    " (a busca é pela chave técnica, porque o número só nasce no adjust_numbers)
    ASSIGN novos[ chamado_uuid = linha-chamado_uuid ] TO FIELD-SYMBOL(<novo>).
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
    DATA(chamado) = ler( chamado_id = chamado_id
                         pid        = pid ).
    CHECK chamado IS NOT INITIAL.

    " criado e excluído na mesma transação: nunca chegou ao banco, basta esquecer
    IF line_exists( novos[ chamado_uuid = chamado-chamado_uuid ] ).
      DELETE novos WHERE chamado_uuid = chamado-chamado_uuid.
      RETURN.
    ENDIF.

    DELETE alterados WHERE chamado_uuid = chamado-chamado_uuid.
    APPEND chamado TO excluidos.
  ENDMETHOD.

  METHOD ler.
    " criado nesta transação: ainda sem número, só com a identificação provisória (%pid)
    IF pid IS NOT INITIAL.
      result = VALUE #( novos[ chamado_uuid = pid ] OPTIONAL ).
      RETURN.
    ENDIF.

    IF chamado_id IS INITIAL.
      RETURN.
    ENDIF.

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

  METHOD novo_uuid.
    TRY.
        result = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error INTO DATA(erro).
        RAISE SHORTDUMP erro.
    ENDTRY.
  ENDMETHOD.

  METHOD numerar.
    " chamado só no adjust_numbers: o número definitivo nasce no último instante antes do save
    LOOP AT novos ASSIGNING FIELD-SYMBOL(<novo>) WHERE chamado_id IS INITIAL.
      <novo>-chamado_id = proximo_id( ).
    ENDLOOP.

    result = novos.
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
