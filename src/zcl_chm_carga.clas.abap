CLASS zcl_chm_carga DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_carga IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA chamados     TYPE STANDARD TABLE OF zchm_chamado WITH EMPTY KEY.
    DATA apontamentos TYPE STANDARD TABLE OF zchm_apont WITH EMPTY KEY.

    DELETE FROM zchm_apont.
    DELETE FROM zchm_chamado.

    chamados = VALUE #(
      ( chamado_id = 1 titulo = 'Fatura duplicada no fechamento'
        cliente = '0000100017' prioridade = 'M' status = 'A' horas_total = '4.50' )
      ( chamado_id = 2 titulo = 'Lentidão no relatório de estoque'
        cliente = '0000100023' prioridade = 'B' status = 'A' horas_total = '1.00' )
      ( chamado_id = 3 titulo = 'Usuário sem acesso à transação'
        cliente = '0000100041' prioridade = 'A' status = 'E' horas_total = '0.50' ) ).

    DATA agora TYPE timestampl.
    GET TIME STAMP FIELD agora.

    LOOP AT chamados ASSIGNING FIELD-SYMBOL(<chamado>).
      TRY.
          <chamado>-chamado_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
          ASSERT 1 = 0.
      ENDTRY.
      <chamado>-created_by            = sy-uname.
      <chamado>-created_at            = agora.
      <chamado>-last_changed_by       = sy-uname.
      <chamado>-last_changed_at       = agora.
      <chamado>-local_last_changed_at = agora.
    ENDLOOP.

    apontamentos = VALUE #(
      ( chamado_uuid = chamados[ 1 ]-chamado_uuid data_apont = '20261118' horas = '3.00'
        descricao = 'Análise do lançamento em duplicidade' )
      ( chamado_uuid = chamados[ 1 ]-chamado_uuid data_apont = '20261119' horas = '1.50'
        descricao = 'Estorno e reprocessamento' )
      ( chamado_uuid = chamados[ 2 ]-chamado_uuid data_apont = '20261119' horas = '1.00'
        descricao = 'Trace do relatório de estoque' )
      ( chamado_uuid = chamados[ 3 ]-chamado_uuid data_apont = '20261117' horas = '0.50'
        descricao = 'Liberação do perfil de acesso' ) ).

    LOOP AT apontamentos ASSIGNING FIELD-SYMBOL(<apont>).
      TRY.
          <apont>-apont_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
          ASSERT 1 = 0.
      ENDTRY.
      <apont>-created_by            = sy-uname.
      <apont>-created_at            = agora.
      <apont>-last_changed_by       = sy-uname.
      <apont>-last_changed_at       = agora.
      <apont>-local_last_changed_at = agora.
    ENDLOOP.

    INSERT zchm_chamado FROM TABLE @chamados.
    out->write( |{ sy-dbcnt } chamados gravados.| ).

    INSERT zchm_apont FROM TABLE @apontamentos.
    out->write( |{ sy-dbcnt } apontamentos gravados.| ).
  ENDMETHOD.
ENDCLASS.
