CLASS zcl_chm_eml_demo DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_eml_demo IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    MODIFY ENTITIES OF ZR_Chamado
      ENTITY Chamado
        CREATE FIELDS ( Titulo Cliente Prioridade )
        WITH VALUE #( ( %cid       = 'NOVO1'
                        Titulo     = 'Impressora fiscal sem comunicação'
                        Cliente    = '100023'
                        Prioridade = 'M' ) )
      MAPPED DATA(mapped)
      FAILED DATA(failed)
      REPORTED DATA(reported).

    COMMIT ENTITIES.

    DATA(uuid) = mapped-chamado[ 1 ]-ChamadoUUID.
    out->write( |Criado: { uuid }| ).

    MODIFY ENTITIES OF ZR_Chamado
      ENTITY Chamado
        UPDATE FIELDS ( Prioridade )
        WITH VALUE #( ( ChamadoUUID = uuid
                        Prioridade  = 'A' ) )
      FAILED failed
      REPORTED reported.

    COMMIT ENTITIES.
  ENDMETHOD.
ENDCLASS.
