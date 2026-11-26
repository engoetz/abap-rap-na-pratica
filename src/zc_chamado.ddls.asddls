@Metadata.allowExtensions: true
@Search.searchable: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Chamado - projeção para o app'
@ObjectModel.semanticKey: [ 'ChamadoID' ]
define root view entity ZC_Chamado
  provider contract transactional_query
  as projection on ZR_Chamado
{
  key ChamadoUUID,
      ChamadoID,
      @Search.defaultSearchElement: true
      Titulo,
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZI_ClienteVH', element: 'Cliente' } }]
      Cliente,
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZI_PrioridadeVH', element: 'Prioridade' } }]
      @ObjectModel.text.element: [ 'PrioridadeTexto' ]
      Prioridade,
      _Prioridade.Descricao   as PrioridadeTexto,
      _Prioridade.Criticidade as PrioridadeCriticidade,
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZI_StatusVH', element: 'Status' } }]
      @ObjectModel.text.element: [ 'StatusTexto' ]
      Status,
      _Status.Descricao       as StatusTexto,
      _Status.Criticidade     as StatusCriticidade,
      HorasTotal,
      Descricao,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
