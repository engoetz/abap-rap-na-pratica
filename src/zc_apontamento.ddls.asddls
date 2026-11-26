@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Apontamento de horas'
@Metadata.allowExtensions: true
define view entity ZC_Apontamento
  as projection on ZR_Apontamento
{
  key ApontUUID,
      ChamadoUUID,
      DataApont,
      Horas,
      Descricao,
      LocalLastChangedAt,
      _Chamado : redirected to parent ZC_Chamado
}
