CLASS lhc_Chamado DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Chamado RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Chamado.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Chamado.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Chamado.

    METHODS read FOR READ
      IMPORTING keys FOR READ Chamado RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Chamado.

ENDCLASS.

CLASS lhc_Chamado IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    LOOP AT entities INTO DATA(entidade).
      DATA(chamado) = CORRESPONDING zchm_chamado( entidade MAPPING FROM ENTITY ).
      chamado-chamado_id = zcl_chm_buffer=>proximo_id( ).
      chamado-status     = 'A'.
      zcl_chm_buffer=>incluir( chamado ).

      INSERT VALUE #( %cid      = entidade-%cid
                      ChamadoID = chamado-chamado_id ) INTO TABLE mapped-chamado.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    LOOP AT entities INTO DATA(entidade).
      DATA(chamado) = zcl_chm_buffer=>ler( entidade-ChamadoID ).
      IF chamado IS INITIAL.
        APPEND VALUE #( %tky        = entidade-%tky
                        %fail-cause = if_abap_behv=>cause-not_found ) TO failed-chamado.
        CONTINUE.
      ENDIF.

      chamado = CORRESPONDING #( BASE ( chamado ) entidade
                                 MAPPING FROM ENTITY USING CONTROL ).
      zcl_chm_buffer=>alterar( chamado ).
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(chave).
      zcl_chm_buffer=>excluir( chave-ChamadoID ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(chave).
      DATA(chamado) = zcl_chm_buffer=>ler( chave-ChamadoID ).
      IF chamado IS INITIAL.
        APPEND VALUE #( %tky        = chave-%tky
                        %fail-cause = if_abap_behv=>cause-not_found ) TO failed-chamado.
        CONTINUE.
      ENDIF.

      INSERT CORRESPONDING #( chamado MAPPING TO ENTITY ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
    TRY.
        DATA(bloqueio) = cl_abap_lock_object_factory=>get_instance(
                           iv_name = 'EZCHM_CHAMADO' ).

        LOOP AT keys INTO DATA(chave).
          DATA(chamado) = zcl_chm_buffer=>ler( chave-ChamadoID ).

          " chave que não existe, ou chamado criado nesta transação e ainda sem
          " chave técnica: não há linha no banco para bloquear
          IF chamado-chamado_uuid IS INITIAL.
            CONTINUE.
          ENDIF.

          bloqueio->enqueue( it_parameter = VALUE #(
            ( name = 'CHAMADO_UUID' value = REF #( chamado-chamado_uuid ) ) ) ).
        ENDLOOP.

      CATCH cx_abap_foreign_lock.
        APPEND VALUE #( %tky        = chave-%tky
                        %fail-cause = if_abap_behv=>cause-locked ) TO failed-chamado.
      CATCH cx_abap_lock_failure INTO DATA(erro).
        RAISE SHORTDUMP erro.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZR_ChamadoU DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_ChamadoU IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    zcl_chm_buffer=>gravar( ).
  ENDMETHOD.

  METHOD cleanup.
    zcl_chm_buffer=>limpar( ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
