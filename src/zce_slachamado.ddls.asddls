@EndUserText.label: 'SLA do chamado'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CHM_SLA_QUERY'
define custom entity ZCE_SlaChamado
{
      @UI.lineItem: [{ position: 10 }]
      @EndUserText.label: 'Chamado'
  key ChamadoID      : abap.int4;
      @UI.lineItem: [{ position: 20 }]
      @EndUserText.label: 'Prazo em horas'
      PrazoHoras     : abap.int4;
      @UI.lineItem: [{ position: 30 }]
      @EndUserText.label: 'Horas restantes'
      HorasRestantes : abap.int4;
      @UI.lineItem: [{ position: 40 }]
      @EndUserText.label: 'Situação'
      Situacao       : abap.char( 12 );
}
