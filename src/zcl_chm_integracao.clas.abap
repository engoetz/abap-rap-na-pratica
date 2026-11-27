CLASS zcl_chm_integracao DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_integracao IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    MODIFY ENTITIES OF ZI_ChamadoTP
      ENTITY Chamado
        CREATE FIELDS ( Titulo Cliente Prioridade )
        WITH VALUE #( ( %cid       = 'NOVO'
                        Titulo     = 'Aberto pela integração'
                        Cliente    = '100017'
                        Prioridade = 'M' ) )
      MAPPED DATA(mapped)
      FAILED DATA(failed)
      REPORTED DATA(reported).

    COMMIT ENTITIES.
    out->write( |Chamados criados: { lines( mapped-chamado ) }| ).
  ENDMETHOD.

ENDCLASS.
