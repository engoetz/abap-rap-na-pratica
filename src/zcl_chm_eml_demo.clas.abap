CLASS zcl_chm_eml_demo DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_eml_demo IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    MODIFY ENTITIES OF ZR_Chamado
      ENTITY Chamado
        CREATE FIELDS ( Cliente Prioridade )
        WITH VALUE #( ( %cid       = 'NOVO1'
                        Cliente    = '100017'
                        Prioridade = 'M' ) )
      MAPPED DATA(mapped)
      FAILED DATA(failed)
      REPORTED DATA(reported).

    out->write( |Falhas no modify: { lines( failed-chamado ) }| ).

    COMMIT ENTITIES
      RESPONSE OF ZR_Chamado
      FAILED DATA(failed_commit)
      REPORTED DATA(reported_commit).

    IF sy-subrc <> 0.
      LOOP AT reported_commit-chamado INTO DATA(r).
        out->write( r-%msg->if_message~get_text( ) ).
        IF r-%element-Titulo = if_abap_behv=>mk-on.
          out->write( 'Campo com problema: Titulo' ).
        ENDIF.
      ENDLOOP.
      ROLLBACK ENTITIES.
    ELSE.
      out->write( 'Chamado gravado.' ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
