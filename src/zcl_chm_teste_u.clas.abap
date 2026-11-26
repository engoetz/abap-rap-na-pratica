CLASS zcl_chm_teste_u DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_teste_u IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    MODIFY ENTITIES OF ZR_ChamadoU
      ENTITY Chamado
        CREATE FIELDS ( Titulo Cliente Prioridade )
        WITH VALUE #( ( %cid       = 'NOVO'
                        Titulo     = 'Impressora não imprime etiqueta'
                        Cliente    = '100017'
                        Prioridade = 'M' ) )
      MAPPED DATA(mapeados)
      FAILED DATA(falhas).

    COMMIT ENTITIES.

    out->write( |Falhas: { lines( falhas-chamado ) }| ).
    out->write( |Criados: { lines( mapeados-chamado ) }| ).
  ENDMETHOD.

ENDCLASS.
