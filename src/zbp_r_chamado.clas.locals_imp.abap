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

    LOOP AT chamados INTO DATA(chamado) WHERE Titulo IS INITIAL.
      APPEND VALUE #( %tky = chamado-%tky ) TO failed-chamado.

      APPEND VALUE #( %tky = chamado-%tky
                      %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Informe o título do chamado' ) )
             TO reported-chamado.
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
      IF line_exists( clientes[ Cliente = chamado-Cliente ] ).
        CONTINUE.
      ENDIF.

      APPEND VALUE #( %tky = chamado-%tky ) TO failed-chamado.

      APPEND VALUE #( %tky = chamado-%tky
                      %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Cliente { chamado-Cliente } não existe| ) )
             TO reported-chamado.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
