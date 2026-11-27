CLASS lhc_Chamado DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Chamado RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Chamado
      RESULT result.

    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE Chamado.

    METHODS definirStatusInicial FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Chamado~definirStatusInicial.

    METHODS definirNumero FOR DETERMINE ON SAVE
      IMPORTING keys FOR Chamado~definirNumero.

    METHODS validarTitulo FOR VALIDATE ON SAVE
      IMPORTING keys FOR Chamado~validarTitulo.

    METHODS validarCliente FOR VALIDATE ON SAVE
      IMPORTING keys FOR Chamado~validarCliente.

    METHODS encerrar FOR MODIFY
      IMPORTING keys FOR ACTION Chamado~encerrar RESULT result.

    METHODS encerrarComMotivo FOR MODIFY
      IMPORTING keys FOR ACTION Chamado~encerrarComMotivo RESULT result.

    METHODS copiar FOR MODIFY
      IMPORTING keys FOR ACTION Chamado~copiar.

    METHODS ResumoChamados FOR READ
      IMPORTING keys FOR FUNCTION Chamado~ResumoChamados RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Chamado RESULT result.

    METHODS escalarPrioridade FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Chamado~escalarPrioridade.

ENDCLASS.

CLASS lhc_Chamado IMPLEMENTATION.

  METHOD get_instance_authorizations.

    CHECK requested_authorizations-%action-encerrar = if_abap_behv=>mk-on.

    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        FIELDS ( CreatedBy )
        WITH CORRESPONDING #( keys )
      RESULT DATA(chamados).

    AUTHORITY-CHECK OBJECT 'ZCHM_CHAM'
      ID 'ACTVT' FIELD '70'.
    DATA(gestor) = xsdbool( sy-subrc = 0 ).

    LOOP AT chamados INTO DATA(chamado).
      APPEND VALUE #(
        %tky             = chamado-%tky
        %action-encerrar = COND #(
          WHEN gestor = abap_true OR chamado-CreatedBy = sy-uname
          THEN if_abap_behv=>auth-allowed
          ELSE if_abap_behv=>auth-unauthorized ) ) TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.

    IF requested_authorizations-%create = if_abap_behv=>mk-on.

      AUTHORITY-CHECK OBJECT 'ZCHM_CHAM'
        ID 'ACTVT' FIELD '01'.

      result-%create = COND #(
        WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
        ELSE if_abap_behv=>auth-unauthorized ).

    ENDIF.

  ENDMETHOD.

  METHOD precheck_update.

    AUTHORITY-CHECK OBJECT 'ZCHM_CHAM'
      ID 'ACTVT' FIELD '70'.
    CHECK sy-subrc <> 0.

    LOOP AT entities INTO DATA(entidade)
         WHERE %control-Prioridade = if_abap_behv=>mk-on
           AND Prioridade = 'A'.

      APPEND VALUE #( %tky        = entidade-%tky
                      %fail-cause = if_abap_behv=>cause-unauthorized ) TO failed-chamado.

      APPEND VALUE #(
        %tky                = entidade-%tky
        %element-Prioridade = if_abap_behv=>mk-on
        %msg                = new_message(
          id       = 'ZCHM_MSG'
          number   = '020'
          severity = if_abap_behv_message=>severity-error ) ) TO reported-chamado.

    ENDLOOP.

  ENDMETHOD.

  METHOD definirStatusInicial.
    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(chamados).

    DELETE chamados WHERE Status IS NOT INITIAL.
    CHECK chamados IS NOT INITIAL.

    MODIFY ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR chamado IN chamados
                      ( %tky   = chamado-%tky
                        Status = 'A' ) ).
  ENDMETHOD.

  METHOD definirNumero.
    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        FIELDS ( ChamadoID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(chamados).

    DELETE chamados WHERE ChamadoID IS NOT INITIAL.
    CHECK chamados IS NOT INITIAL.

    SELECT SINGLE FROM zchm_chamado
      FIELDS MAX( chamado_id )
      INTO @DATA(ultimo).

    MODIFY ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        UPDATE FIELDS ( ChamadoID )
        WITH VALUE #( FOR chamado IN chamados INDEX INTO i
                      ( %tky      = chamado-%tky
                        ChamadoID = ultimo + i ) ).
  ENDMETHOD.

  METHOD validarTitulo.
    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        FIELDS ( Titulo )
        WITH CORRESPONDING #( keys )
      RESULT DATA(chamados).

    LOOP AT chamados INTO DATA(chamado).
      APPEND VALUE #( %tky        = chamado-%tky
                      %state_area = 'VALIDAR_TITULO' ) TO reported-chamado.

      IF chamado-Titulo IS INITIAL.
        APPEND VALUE #( %tky = chamado-%tky ) TO failed-chamado.

        APPEND VALUE #( %tky            = chamado-%tky
                        %state_area     = 'VALIDAR_TITULO'
                        %element-Titulo = if_abap_behv=>mk-on
                        %msg            = new_message(
                          id       = 'ZCHM_MSG'
                          number   = '001'
                          severity = if_abap_behv_message=>severity-error ) )
               TO reported-chamado.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validarCliente.
    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        FIELDS ( Cliente )
        WITH CORRESPONDING #( keys )
      RESULT DATA(chamados).

    SELECT FROM ZI_ClienteVH
      FIELDS Cliente
      FOR ALL ENTRIES IN @chamados
      WHERE Cliente = @chamados-Cliente
      INTO TABLE @DATA(clientes).

    LOOP AT chamados INTO DATA(chamado).
      APPEND VALUE #( %tky        = chamado-%tky
                      %state_area = 'VALIDAR_CLIENTE' ) TO reported-chamado.

      IF line_exists( clientes[ Cliente = chamado-Cliente ] ).
        CONTINUE.
      ENDIF.

      APPEND VALUE #( %tky = chamado-%tky ) TO failed-chamado.

      APPEND VALUE #( %tky             = chamado-%tky
                      %state_area      = 'VALIDAR_CLIENTE'
                      %element-Cliente = if_abap_behv=>mk-on
                      %msg             = new_message(
                        id       = 'ZCHM_MSG'
                        number   = '002'
                        severity = if_abap_behv_message=>severity-error
                        v1       = chamado-Cliente ) )
             TO reported-chamado.
    ENDLOOP.
  ENDMETHOD.

  METHOD encerrar.
    MODIFY ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys
                      ( %tky   = key-%tky
                        Status = 'E' ) ).

    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(chamados).

    result = VALUE #( FOR chamado IN chamados
                      ( %tky   = chamado-%tky
                        %param = chamado ) ).
  ENDMETHOD.

  METHOD encerrarComMotivo.
    DATA alteracoes TYPE TABLE FOR UPDATE ZR_Chamado.

    LOOP AT keys INTO DATA(key).
      IF key-%param-Motivo IS INITIAL.
        APPEND VALUE #( %tky = key-%tky ) TO failed-chamado.
        APPEND VALUE #( %tky = key-%tky
                        %msg = new_message(
                          id       = 'ZCHM_MSG'
                          number   = '003'
                          severity = if_abap_behv_message=>severity-error ) )
               TO reported-chamado.
        CONTINUE.
      ENDIF.

      APPEND VALUE #( %tky      = key-%tky
                      Status    = 'E'
                      Descricao = |Encerrado: { key-%param-Motivo }| )
             TO alteracoes.
    ENDLOOP.

    MODIFY ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        UPDATE FIELDS ( Status Descricao ) WITH alteracoes.

    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(chamados).

    result = VALUE #( FOR chamado IN chamados
                      ( %tky   = chamado-%tky
                        %param = chamado ) ).
  ENDMETHOD.

  METHOD copiar.
    DATA novos TYPE TABLE FOR CREATE ZR_Chamado.

    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(originais).

    LOOP AT originais INTO DATA(original).
      DATA(key) = keys[ KEY entity %key = original-%key ].

      APPEND VALUE #( %cid       = key-%cid
                      %is_draft  = key-%param-%is_draft
                      Titulo     = |Cópia de { original-Titulo }|
                      Cliente    = original-Cliente
                      Prioridade = original-Prioridade
                      Descricao  = original-Descricao ) TO novos.
    ENDLOOP.

    MODIFY ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        CREATE FIELDS ( Titulo Cliente Prioridade Descricao )
        WITH novos
      MAPPED DATA(criados).

    mapped-chamado = criados-chamado.
  ENDMETHOD.

  METHOD ResumoChamados.
    DATA resumo TYPE za_resumochamados.

    SELECT Status, COUNT(*) AS Quantidade, SUM( HorasTotal ) AS Horas
      FROM ZR_Chamado
      GROUP BY Status
      INTO TABLE @DATA(grupos).

    LOOP AT grupos INTO DATA(grupo).
      IF grupo-Status = 'A'.
        resumo-Abertos = grupo-Quantidade.
      ELSE.
        resumo-Encerrados = grupo-Quantidade.
      ENDIF.
      resumo-HorasTotais = resumo-HorasTotais + grupo-Horas.
    ENDLOOP.

    result = VALUE #( FOR key IN keys
                      ( %cid = key-%cid  %param = resumo ) ).
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(chamados).

    LOOP AT chamados INTO DATA(chamado).
      IF chamado-Status = 'E'.
        APPEND VALUE #(
          %tky                      = chamado-%tky
          %action-encerrar          = if_abap_behv=>fc-o-disabled
          %action-encerrarComMotivo = if_abap_behv=>fc-o-disabled
          %field-Titulo             = if_abap_behv=>fc-f-read_only
          %field-Cliente            = if_abap_behv=>fc-f-read_only
          %field-Prioridade         = if_abap_behv=>fc-f-read_only
          %field-Descricao          = if_abap_behv=>fc-f-read_only ) TO result.
      ELSE.
        APPEND VALUE #(
          %tky           = chamado-%tky
          %field-Titulo  = if_abap_behv=>fc-f-mandatory
          %field-Cliente = if_abap_behv=>fc-f-mandatory ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD escalarPrioridade.
    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        FIELDS ( HorasTotal Prioridade )
        WITH CORRESPONDING #( keys )
      RESULT DATA(chamados).

    DELETE chamados WHERE HorasTotal <= 40 OR Prioridade = 'A'.
    CHECK chamados IS NOT INITIAL.

    MODIFY ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        UPDATE FIELDS ( Prioridade )
        WITH VALUE #( FOR chamado IN chamados
                      ( %tky       = chamado-%tky
                        Prioridade = 'A' ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Apontamento DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calcularTotalHoras FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Apontamento~calcularTotalHoras.

    METHODS validarHoras FOR VALIDATE ON SAVE
      IMPORTING keys FOR Apontamento~validarHoras.

    METHODS validarData FOR VALIDATE ON SAVE
      IMPORTING keys FOR Apontamento~validarData.

ENDCLASS.

CLASS lhc_Apontamento IMPLEMENTATION.

  METHOD calcularTotalHoras.
    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Apontamento BY \_Chamado
        FIELDS ( ChamadoUUID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(chamados).

    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado BY \_Apontamentos
        FIELDS ( ChamadoUUID Horas )
        WITH CORRESPONDING #( chamados )
      RESULT DATA(apontamentos).

    LOOP AT chamados ASSIGNING FIELD-SYMBOL(<chamado>).
      CLEAR <chamado>-HorasTotal.
      LOOP AT apontamentos INTO DATA(apont)
           WHERE ChamadoUUID = <chamado>-ChamadoUUID
             AND %is_draft   = <chamado>-%is_draft.
        <chamado>-HorasTotal += apont-Horas.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado
        UPDATE FIELDS ( HorasTotal )
        WITH VALUE #( FOR c IN chamados
                      ( %tky = c-%tky  HorasTotal = c-HorasTotal ) ).
  ENDMETHOD.

  METHOD validarHoras.
    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Apontamento
        FIELDS ( ChamadoUUID Horas )
        WITH CORRESPONDING #( keys )
      RESULT DATA(apontamentos).

    LOOP AT apontamentos INTO DATA(apont).
      APPEND VALUE #( %tky        = apont-%tky
                      %state_area = 'HORAS' ) TO reported-apontamento.

      CHECK apont-Horas <= 0.

      APPEND VALUE #( %tky = apont-%tky ) TO failed-apontamento.
      APPEND VALUE #(
        %tky           = apont-%tky
        %state_area    = 'HORAS'
        %path          = VALUE #( chamado-%is_draft   = apont-%is_draft
                                  chamado-ChamadoUUID = apont-ChamadoUUID )
        %element-Horas = if_abap_behv=>mk-on
        %msg           = new_message( id       = 'ZCHM_MSG'
                                      number   = '010'
                                      severity = if_abap_behv_message=>severity-error )
      ) TO reported-apontamento.
    ENDLOOP.
  ENDMETHOD.

  METHOD validarData.
    DATA(hoje) = cl_abap_context_info=>get_system_date( ).

    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Apontamento
        FIELDS ( ChamadoUUID DataApont )
        WITH CORRESPONDING #( keys )
      RESULT DATA(apontamentos).

    LOOP AT apontamentos INTO DATA(apont).
      APPEND VALUE #( %tky        = apont-%tky
                      %state_area = 'DATA' ) TO reported-apontamento.

      CHECK apont-DataApont > hoje.

      APPEND VALUE #( %tky = apont-%tky ) TO failed-apontamento.
      APPEND VALUE #(
        %tky               = apont-%tky
        %state_area        = 'DATA'
        %path              = VALUE #( chamado-%is_draft   = apont-%is_draft
                                      chamado-ChamadoUUID = apont-ChamadoUUID )
        %element-DataApont = if_abap_behv=>mk-on
        %msg               = new_message( id       = 'ZCHM_MSG'
                                          number   = '011'
                                          severity = if_abap_behv_message=>severity-error )
      ) TO reported-apontamento.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZR_Chamado DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_Chamado IMPLEMENTATION.

  METHOD finalize.
    DATA(fase) = 'finalize'.
  ENDMETHOD.

  METHOD check_before_save.
    DATA(fase) = 'check before save'.
  ENDMETHOD.

  METHOD save_modified.
    DATA chamados TYPE zcl_chm_log_legado=>tt_chamado.

    IF create-chamado IS NOT INITIAL.
      chamados = CORRESPONDING #( create-chamado MAPPING FROM ENTITY ).
      zcl_chm_log_legado=>gravar( chamados = chamados operacao = 'C' ).
    ENDIF.

    IF update-chamado IS NOT INITIAL.
      chamados = CORRESPONDING #( update-chamado MAPPING FROM ENTITY ).
      zcl_chm_log_legado=>gravar( chamados = chamados operacao = 'U' ).
    ENDIF.

    LOOP AT delete-chamado INTO DATA(excluido).
      zcl_chm_log_legado=>excluir( excluido-ChamadoUUID ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
