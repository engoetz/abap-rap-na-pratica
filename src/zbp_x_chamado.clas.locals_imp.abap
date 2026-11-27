CLASS lhc_chamado DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS zzExigirDescricao FOR VALIDATE ON SAVE
      IMPORTING keys FOR Chamado~zzExigirDescricao.
ENDCLASS.

CLASS lhc_chamado IMPLEMENTATION.
  METHOD zzExigirDescricao.
    READ ENTITIES OF ZR_Chamado IN LOCAL MODE
      ENTITY Chamado FIELDS ( Prioridade Descricao )
      WITH CORRESPONDING #( keys )
      RESULT DATA(chamados).

    LOOP AT chamados INTO DATA(chamado)
         WHERE Prioridade = 'A' AND Descricao IS INITIAL.
      APPEND VALUE #( %tky = chamado-%tky ) TO failed-chamado.
      APPEND VALUE #( %tky = chamado-%tky
                      %element-Descricao = if_abap_behv=>mk-on
                      %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Prioridade alta exige descrição' ) )
             TO reported-chamado.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
