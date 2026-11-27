"! @testing BDEF:ZR_Chamado
CLASS zcl_chm_teste_chamado DEFINITION
  PUBLIC FINAL CREATE PUBLIC
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS teardown.
    METHODS sem_titulo_nao_grava FOR TESTING.
ENDCLASS.

CLASS zcl_chm_teste_chamado IMPLEMENTATION.

  METHOD sem_titulo_nao_grava.
    MODIFY ENTITIES OF ZR_Chamado
      ENTITY Chamado
        CREATE FIELDS ( Cliente Prioridade )
        WITH VALUE #( ( %cid       = 'SEM_TITULO'
                        Cliente    = '100017'
                        Prioridade = 'M' ) )
      FAILED DATA(failed).
    cl_abap_unit_assert=>assert_initial( failed ).

    COMMIT ENTITIES RESPONSE OF ZR_Chamado
      FAILED DATA(falhas_save).

    cl_abap_unit_assert=>assert_not_initial(
      act = falhas_save-chamado
      msg = 'Chamado sem título não pode ser gravado' ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.

ENDCLASS.
