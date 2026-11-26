@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Chamado de suporte'
define root view entity ZR_Chamado
  as select from zchm_chamado
  association [0..1] to ZI_ClienteVH    as _Cliente
    on $projection.Cliente = _Cliente.Cliente
  association [0..1] to ZI_PrioridadeVH as _Prioridade
    on $projection.Prioridade = _Prioridade.Prioridade
  association [0..1] to ZI_StatusVH     as _Status
    on $projection.Status = _Status.Status
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
      local_last_changed_at as LocalLastChangedAt,
      _Cliente,
      _Prioridade,
      _Status
}
