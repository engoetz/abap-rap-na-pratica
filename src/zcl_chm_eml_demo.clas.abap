CLASS zcl_chm_eml_demo DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_eml_demo IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(hoje) = cl_abap_context_info=>get_system_date( ).

    SELECT SINGLE ChamadoUUID FROM ZR_Chamado
      WHERE Titulo LIKE 'Lentidão%'
      INTO @DATA(uuid).

    MODIFY ENTITIES OF ZR_Chamado
      ENTITY Chamado
        CREATE BY \_Apontamentos
        FIELDS ( DataApont Horas Descricao )
        WITH VALUE #( ( ChamadoUUID = uuid
                        %target = VALUE #( (
                          %cid      = 'AP1'
                          DataApont = hoje
                          Horas     = '1.5'
                          Descricao = 'Análise do plano de execução' ) ) ) )
      FAILED DATA(failed)
      REPORTED DATA(reported).

    COMMIT ENTITIES.

    MODIFY ENTITIES OF ZR_Chamado
      ENTITY Chamado
        CREATE FIELDS ( Titulo Cliente Prioridade )
        WITH VALUE #( ( %cid       = 'CHM1'
                        Titulo     = 'Etiqueta sai cortada na expedição'
                        Cliente    = '100023'
                        Prioridade = 'B' ) )
        CREATE BY \_Apontamentos
        FIELDS ( DataApont Horas Descricao )
        WITH VALUE #( ( %cid_ref = 'CHM1'
                        %target  = VALUE #(
                          ( %cid = 'AP1' DataApont = hoje Horas = 2
                            Descricao = 'Teste na impressora' )
                          ( %cid = 'AP2' DataApont = hoje Horas = 1
                            Descricao = 'Ajuste do formulário' ) ) ) )
      MAPPED DATA(mapped)
      FAILED failed
      REPORTED reported.

    COMMIT ENTITIES.
    out->write( |Chamados: { lines( mapped-chamado ) }| ).
    out->write( |Apontamentos: { lines( mapped-apontamento ) }| ).
  ENDMETHOD.
ENDCLASS.
