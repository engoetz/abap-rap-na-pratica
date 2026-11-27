CLASS lhe_chamado DEFINITION
  INHERITING FROM cl_abap_behavior_event_handler.
  PRIVATE SECTION.
    METHODS ao_encerrar FOR ENTITY EVENT encerrados
      FOR Chamado~ChamadoEncerrado.
ENDCLASS.

CLASS lhe_chamado IMPLEMENTATION.
  METHOD ao_encerrar.
    " aqui entra o e-mail, o faturamento, a chamada de API
    DATA logs TYPE STANDARD TABLE OF zchm_log WITH EMPTY KEY.

    TRY.
        logs = VALUE #( FOR encerrado IN encerrados
                 ( log_uuid      = cl_system_uuid=>create_uuid_x16_static( )
                   chamado_uuid  = encerrado-ChamadoUUID
                   operacao      = 'E'
                   usuario       = sy-uname
                   registrado_em = utclong_current( ) ) ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

    " o handler começa na fase de modificação; gravação em banco só na fase de save
    cl_abap_tx=>save( ).
    INSERT zchm_log FROM TABLE @logs.
  ENDMETHOD.
ENDCLASS.
