CLASS zcl_chm_eml_demo DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_eml_demo IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    SELECT ChamadoUUID FROM ZR_Chamado
      WHERE Status = 'A'
      INTO TABLE @DATA(abertos).

    READ ENTITIES OF ZR_Chamado
      ENTITY Chamado
        FIELDS ( ChamadoID Titulo )
        WITH CORRESPONDING #( abertos )
      RESULT DATA(chamados)
      FAILED DATA(failed)
      REPORTED DATA(reported).

    LOOP AT chamados INTO DATA(chamado).
      out->write( |{ chamado-ChamadoID } - { chamado-Titulo }| ).
    ENDLOOP.

    READ ENTITIES OF ZR_Chamado
      ENTITY Chamado BY \_Apontamentos
        ALL FIELDS
        WITH CORRESPONDING #( abertos )
      RESULT DATA(apontamentos).

    LOOP AT apontamentos INTO DATA(apont).
      out->write( |{ apont-DataApont DATE = ISO } { apont-Horas } { apont-Descricao }| ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
