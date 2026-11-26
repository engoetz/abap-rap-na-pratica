CLASS lhc_Chamado DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Chamado RESULT result.

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

ENDCLASS.

CLASS lhc_Chamado IMPLEMENTATION.

  METHOD get_instance_authorizations.
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

ENDCLASS.
