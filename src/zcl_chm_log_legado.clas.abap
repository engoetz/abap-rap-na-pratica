CLASS zcl_chm_log_legado DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES tt_chamado TYPE STANDARD TABLE OF zchm_chamado WITH EMPTY KEY.

    CLASS-METHODS gravar
      IMPORTING chamados TYPE tt_chamado
                operacao TYPE zchm_log-operacao.

    CLASS-METHODS excluir
      IMPORTING chamado_uuid TYPE zchm_chamado-chamado_uuid.

  PRIVATE SECTION.
    CLASS-METHODS registrar_log
      IMPORTING chamados TYPE tt_chamado
                operacao TYPE zchm_log-operacao.

    CLASS-METHODS novo_uuid
      RETURNING VALUE(result) TYPE sysuuid_x16.
ENDCLASS.

CLASS zcl_chm_log_legado IMPLEMENTATION.

  METHOD gravar.
    DATA agora TYPE timestampl.

    CHECK chamados IS NOT INITIAL.

    DATA(linhas) = chamados.
    GET TIME STAMP FIELD agora.

    " quem chama sem a chave técnica ou sem os campos administrativos
    " recebe os valores daqui; o que já vem preenchido é respeitado
    LOOP AT linhas ASSIGNING FIELD-SYMBOL(<linha>).
      IF <linha>-chamado_uuid IS INITIAL.
        <linha>-chamado_uuid = novo_uuid( ).
      ENDIF.
      IF operacao = 'C' AND <linha>-created_by IS INITIAL.
        <linha>-created_by = sy-uname.
        <linha>-created_at = agora.
      ENDIF.
      IF <linha>-last_changed_by IS INITIAL.
        <linha>-last_changed_by       = sy-uname.
        <linha>-last_changed_at       = agora.
        <linha>-local_last_changed_at = agora.
      ENDIF.
    ENDLOOP.

    MODIFY zchm_chamado FROM TABLE @linhas.

    registrar_log( chamados = linhas
                   operacao = operacao ).
  ENDMETHOD.

  METHOD excluir.
    DELETE FROM zchm_chamado WHERE chamado_uuid = @chamado_uuid.

    registrar_log( chamados = VALUE #( ( chamado_uuid = chamado_uuid ) )
                   operacao = 'D' ).
  ENDMETHOD.

  METHOD registrar_log.
    DATA logs TYPE STANDARD TABLE OF zchm_log WITH EMPTY KEY.

    LOOP AT chamados INTO DATA(chamado).
      APPEND VALUE #( log_uuid      = novo_uuid( )
                      chamado_uuid  = chamado-chamado_uuid
                      operacao      = operacao
                      status        = chamado-status
                      usuario       = sy-uname
                      registrado_em = utclong_current( ) ) TO logs.
    ENDLOOP.

    INSERT zchm_log FROM TABLE @logs.
  ENDMETHOD.

  METHOD novo_uuid.
    TRY.
        result = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error INTO DATA(erro).
        RAISE SHORTDUMP erro.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
