CLASS zcl_chm_teste_u DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_teste_u IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    MODIFY ENTITIES OF ZR_ChamadoU
      ENTITY Chamado
        CREATE FIELDS ( Titulo Cliente )
        WITH VALUE #( ( %cid    = 'NOVO'
                        Titulo  = 'Etiqueta sai cortada'
                        Cliente = '100041' ) )
      MAPPED DATA(mapeados).

    out->write( |Antes do save: { mapeados-chamado[ 1 ]-ChamadoID }| ).

    COMMIT ENTITIES BEGIN
      RESPONSE OF ZR_ChamadoU FAILED DATA(falhas).
      CONVERT KEY OF ZR_ChamadoU
        FROM mapeados-chamado[ 1 ]-%pid TO DATA(chave_final).
    COMMIT ENTITIES END.

    out->write( |Depois do save: { chave_final-ChamadoID }| ).
  ENDMETHOD.

ENDCLASS.
