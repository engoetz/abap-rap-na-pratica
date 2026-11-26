CLASS zcl_chm_eml_demo DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_eml_demo IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    SELECT SINGLE ChamadoUUID FROM ZR_Chamado
      WHERE Titulo LIKE 'Usuário%'
      INTO @DATA(origem).

    MODIFY ENTITIES OF ZR_Chamado
      ENTITY Chamado
        EXECUTE copiar
        FROM VALUE #( ( %cid        = 'COPIA1'
                        ChamadoUUID = origem ) )
      MAPPED DATA(mapped)
      FAILED DATA(failed)
      REPORTED DATA(reported).

    COMMIT ENTITIES.
    out->write( |Cópias criadas: { lines( mapped-chamado ) }| ).
  ENDMETHOD.
ENDCLASS.
