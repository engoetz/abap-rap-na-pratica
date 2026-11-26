@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda de pesquisa de prioridade'
define view entity ZI_PrioridadeVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZCHM_PRIORIDADE' )
{
  key value_low as Prioridade,
      text      as Descricao,
      @UI.hidden: true
      case value_low
        when 'A' then 1
        when 'M' then 2
        else 0
      end       as Criticidade
}
where
  language = $session.system_language
