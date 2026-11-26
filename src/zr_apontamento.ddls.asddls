@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Apontamento de horas'
define view entity ZR_Apontamento
  as select from zchm_apont
  association to parent ZR_Chamado as _Chamado
    on $projection.ChamadoUUID = _Chamado.ChamadoUUID
{
  key apont_uuid            as ApontUUID,
      chamado_uuid          as ChamadoUUID,
      data_apont            as DataApont,
      horas                 as Horas,
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
      _Chamado
}
