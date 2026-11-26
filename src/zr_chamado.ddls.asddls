@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Chamado de suporte'
define root view entity ZR_Chamado
  as select from zchm_chamado
{
  key chamado_uuid          as ChamadoUUID,
      chamado_id            as ChamadoID,
      titulo                as Titulo,
      cliente               as Cliente,
      prioridade            as Prioridade,
      status                as Status,
      horas_total           as HorasTotal,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
