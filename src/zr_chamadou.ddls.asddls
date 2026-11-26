@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Chamado (BO unmanaged de exemplo)'
define root view entity ZR_ChamadoU
  as select from zchm_chamado
{
  key chamado_id      as ChamadoID,
      titulo          as Titulo,
      cliente         as Cliente,
      prioridade      as Prioridade,
      status          as Status,
      last_changed_at as LastChangedAt
}
