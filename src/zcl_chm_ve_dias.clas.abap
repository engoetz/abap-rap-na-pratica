CLASS zcl_chm_ve_dias DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
ENDCLASS.

CLASS zcl_chm_ve_dias IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    APPEND 'CREATEDAT' TO et_requested_orig_elements.
    APPEND 'STATUS' TO et_requested_orig_elements.
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA chamados TYPE STANDARD TABLE OF zc_chamado WITH EMPTY KEY.
    chamados = CORRESPONDING #( it_original_data ).
    DATA(hoje) = cl_abap_context_info=>get_system_date( ).

    LOOP AT chamados ASSIGNING FIELD-SYMBOL(<chamado>).
      CHECK <chamado>-Status = 'A'.
      CONVERT TIME STAMP <chamado>-CreatedAt TIME ZONE 'UTC'
        INTO DATE DATA(criado_em).
      <chamado>-DiasEmAberto = hoje - criado_em.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( chamados ).
  ENDMETHOD.

ENDCLASS.
