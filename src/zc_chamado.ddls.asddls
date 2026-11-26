@Metadata.allowExtensions: true
@Search.searchable: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Chamado - projeção para o app'
define root view entity ZC_Chamado
  provider contract transactional_query
  as projection on ZR_Chamado
{
  key ChamadoUUID,
      ChamadoID,
      @Search.defaultSearchElement: true
      Titulo,
      Cliente,
      Prioridade,
      Status,
      HorasTotal,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
