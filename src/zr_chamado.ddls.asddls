@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Chamado de suporte'
define root view entity ZR_Chamado
  as select from zchm_chamado
  composition [0..*] of ZR_Apontamento as _Apontamentos
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
      @EndUserText.label: 'Descrição'
      descricao             as Descricao,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _Cliente,
      _Prioridade,
      _Status,
      _Apontamentos
}
