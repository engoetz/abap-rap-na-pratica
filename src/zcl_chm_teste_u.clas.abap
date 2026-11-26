CLASS zcl_chm_teste_u DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_teste_u IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    MODIFY ENTITIES OF ZR_ChamadoU
      ENTITY Chamado
        UPDATE FIELDS ( Prioridade )
        WITH VALUE #( ( ChamadoID = 5 Prioridade = 'A' ) ).

    READ ENTITIES OF ZR_ChamadoU
      ENTITY Chamado
        FIELDS ( Prioridade ) WITH VALUE #( ( ChamadoID = 5 ) )
      RESULT DATA(lidos).
    out->write( |Lido antes do commit: { lidos[ 1 ]-Prioridade }| ).

    COMMIT ENTITIES.

    MODIFY ENTITIES OF ZR_ChamadoU
      ENTITY Chamado
        DELETE FROM VALUE #( ( ChamadoID = 5 ) ).
    COMMIT ENTITIES.
  ENDMETHOD.

ENDCLASS.
