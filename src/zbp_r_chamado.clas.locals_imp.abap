CLASS lhc_Chamado DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Chamado RESULT result.

    METHODS definirStatusInicial FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Chamado~definirStatusInicial.

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

ENDCLASS.
