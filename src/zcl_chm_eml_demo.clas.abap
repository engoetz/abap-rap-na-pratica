CLASS zcl_chm_eml_demo DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_eml_demo IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    SELECT SINGLE ChamadoUUID FROM ZR_Chamado
      WHERE Titulo LIKE 'Fatura%'
      INTO @DATA(uuid).

    MODIFY ENTITIES OF ZR_Chamado
      ENTITY Chamado
        EXECUTE encerrar
        FROM VALUE #( ( ChamadoUUID = uuid ) )
      FAILED DATA(failed)
      REPORTED DATA(reported).

    COMMIT ENTITIES.

    SELECT SINGLE Status FROM ZR_Chamado
      WHERE ChamadoUUID = @uuid
      INTO @DATA(status).
    out->write( |Status do chamado: { status }| ).
  ENDMETHOD.
ENDCLASS.
