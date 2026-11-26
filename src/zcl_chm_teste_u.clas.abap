CLASS zcl_chm_teste_u DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_chm_teste_u IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    zcl_chm_buffer=>incluir( VALUE #( chamado_id = 900 titulo = 'Teste do buffer' ) ).
    out->write( zcl_chm_buffer=>ler( 900 )-titulo ).

    SELECT COUNT(*) FROM zchm_chamado WHERE chamado_id = 900 INTO @DATA(no_banco).
    out->write( |No banco: { no_banco }| ).
  ENDMETHOD.

ENDCLASS.
