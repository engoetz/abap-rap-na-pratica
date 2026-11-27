CLASS zcl_chm_sla_query DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.

CLASS zcl_chm_sla_query IMPLEMENTATION.

  METHOD if_rap_query_provider~select.
    DATA sla TYPE STANDARD TABLE OF zce_slachamado WITH EMPTY KEY.

    " Aqui entraria a chamada HTTP da API de SLA. No curso: dados fixos.
    sla = VALUE #(
      ( ChamadoID = 1 PrazoHoras = 24 HorasRestantes = 6  Situacao = 'No prazo' )
      ( ChamadoID = 2 PrazoHoras = 72 HorasRestantes = 40 Situacao = 'No prazo' )
      ( ChamadoID = 3 PrazoHoras = 8  HorasRestantes = 0  Situacao = 'Estourado' ) ).

    " Filtro: o que a tela (ou a leitura de uma linha pela chave) pediu
    DATA faixa_chamado  TYPE RANGE OF zce_slachamado-ChamadoID.
    DATA faixa_situacao TYPE RANGE OF zce_slachamado-Situacao.

    TRY.
        DATA(filtros) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        " filtro que não cabe em faixas: devolve tudo, sem filtrar
        CLEAR filtros.
    ENDTRY.

    LOOP AT filtros INTO DATA(filtro).
      CASE filtro-name.
        WHEN 'CHAMADOID'.
          faixa_chamado = CORRESPONDING #( filtro-range ).
        WHEN 'SITUACAO'.
          faixa_situacao = CORRESPONDING #( filtro-range ).
      ENDCASE.
    ENDLOOP.

    DELETE sla WHERE ChamadoID NOT IN faixa_chamado
                  OR Situacao  NOT IN faixa_situacao.

    " Ordenação: pelas colunas que a tela pediu; sem pedido, pelo número
    DATA(ordem) = VALUE abap_sortorder_tab(
      FOR coluna IN io_request->get_sort_elements( )
      ( name       = coluna-element_name
        descending = coluna-descending ) ).
    IF ordem IS INITIAL.
      ordem = VALUE #( ( name = 'CHAMADOID' ) ).
    ENDIF.
    SORT sla BY (ordem).

    " Paginação
    DATA(total) = lines( sla ).
    DATA(pagina) = io_request->get_paging( ).
    DATA(pular) = pagina->get_offset( ).
    DATA(tamanho) = pagina->get_page_size( ).
    IF pular > 0.
      DELETE sla TO pular.
    ENDIF.
    IF tamanho > 0.
      DELETE sla FROM tamanho + 1.
    ENDIF.

    IF io_request->is_data_requested( ).
      io_response->set_data( sla ).
    ENDIF.
    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( CONV #( total ) ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
