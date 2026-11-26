CLASS zcl_chm_carga DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_carga IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA chamados TYPE STANDARD TABLE OF zchm_chamado WITH EMPTY KEY.

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

    INSERT zchm_chamado FROM TABLE @chamados.
    out->write( |{ sy-dbcnt } chamados gravados.| ).
  ENDMETHOD.
ENDCLASS.
