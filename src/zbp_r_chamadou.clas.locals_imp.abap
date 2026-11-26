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
      chamado-status       = 'A'.
      chamado-chamado_uuid = zcl_chm_buffer=>novo_uuid( ).
      zcl_chm_buffer=>incluir( chamado ).

      INSERT VALUE #( %cid = entidade-%cid
                      %pid = chamado-chamado_uuid ) INTO TABLE mapped-chamado.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    LOOP AT entities INTO DATA(entidade).
      DATA(chamado) = zcl_chm_buffer=>ler( chamado_id = entidade-ChamadoID
                                           pid        = entidade-%pid ).
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
      zcl_chm_buffer=>excluir( chamado_id = chave-ChamadoID
                               pid        = chave-%pid ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    DATA lido LIKE LINE OF result.

    LOOP AT keys INTO DATA(chave).
      DATA(chamado) = zcl_chm_buffer=>ler( chamado_id = chave-ChamadoID
                                           pid        = chave-%pid ).
      IF chamado IS INITIAL.
        APPEND VALUE #( %tky        = chave-%tky
                        %fail-cause = if_abap_behv=>cause-not_found ) TO failed-chamado.
        CONTINUE.
      ENDIF.

      " quem ainda não tem número é devolvido com o mesmo %pid pelo qual foi pedido
      lido      = CORRESPONDING #( chamado MAPPING TO ENTITY ).
      lido-%pid = chave-%pid.
      INSERT lido INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
    TRY.
        DATA(bloqueio) = cl_abap_lock_object_factory=>get_instance(
                           iv_name = 'EZCHM_CHAMADO' ).

        LOOP AT keys INTO DATA(chave).
          DATA(chamado) = zcl_chm_buffer=>ler( chamado_id = chave-ChamadoID
                                               pid        = chave-%pid ).

          " chave que não existe, ou chamado criado nesta transação (ainda só
          " com %pid): não há linha no banco para bloquear
          IF chamado-chamado_uuid IS INITIAL OR chave-%pid IS NOT INITIAL.
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

    METHODS adjust_numbers REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_ChamadoU IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD adjust_numbers.
    LOOP AT zcl_chm_buffer=>numerar( ) INTO DATA(novo).
      APPEND VALUE #( %pid           = novo-chamado_uuid
                      %key-ChamadoID = novo-chamado_id ) TO mapped-chamado.
    ENDLOOP.
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
