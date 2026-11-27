@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Chamado - interface'
define root view entity ZI_ChamadoTP
  provider contract transactional_interface
  as projection on ZR_Chamado
{
  key ChamadoUUID,
      ChamadoID,
      Titulo,
      Cliente,
      Prioridade,
      Status,
      HorasTotal,
      LocalLastChangedAt
}
