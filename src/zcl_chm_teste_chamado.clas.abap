"! @testing BDEF:ZR_Chamado
CLASS zcl_chm_teste_chamado DEFINITION
  PUBLIC FINAL CREATE PUBLIC
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CONSTANTS uuid_teste TYPE sysuuid_x16
      VALUE '11111111111111111111111111111111'.
    CLASS-DATA ambiente TYPE REF TO if_cds_test_environment.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.
    METHODS setup.
    METHODS teardown.
    METHODS sem_titulo_nao_grava FOR TESTING.
    METHODS encerrar_muda_status FOR TESTING.
ENDCLASS.

CLASS zcl_chm_teste_chamado IMPLEMENTATION.

  METHOD class_setup.
    ambiente = cl_cds_test_environment=>create_for_multiple_cds(
      i_for_entities = VALUE #( ( i_for_entity = 'ZR_CHAMADO' )
                                ( i_for_entity = 'ZR_APONTAMENTO' ) ) ).
    ambiente->enable_double_redirection( ).
  ENDMETHOD.

  METHOD setup.
    ambiente->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD class_teardown.
    ambiente->destroy( ).
  ENDMETHOD.

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

  METHOD encerrar_muda_status.
    DATA chamados TYPE STANDARD TABLE OF zchm_chamado.
    chamados = VALUE #( ( chamado_uuid = uuid_teste
                          chamado_id   = 900
                          titulo       = 'Chamado de teste'
                          cliente      = '100017'
                          status       = 'A'
                          created_by   = sy-uname ) ).
    ambiente->insert_test_data( chamados ).

    MODIFY ENTITIES OF ZR_Chamado
      ENTITY Chamado
        EXECUTE encerrar FROM VALUE #( ( ChamadoUUID = uuid_teste ) )
      FAILED DATA(failed).
    cl_abap_unit_assert=>assert_initial( failed ).

    READ ENTITIES OF ZR_Chamado
      ENTITY Chamado
        FIELDS ( Status ) WITH VALUE #( ( ChamadoUUID = uuid_teste ) )
      RESULT DATA(lidos).

    cl_abap_unit_assert=>assert_equals(
      act = lidos[ 1 ]-Status
      exp = 'E' ).
  ENDMETHOD.

ENDCLASS.
