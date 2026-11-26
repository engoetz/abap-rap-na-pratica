@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda de pesquisa de prioridade'
define view entity ZI_PrioridadeVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZCHM_PRIORIDADE' )
{
  key value_low as Prioridade,
      text      as Descricao
}
where
  language = $session.system_language
