@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda de pesquisa de status'
define view entity ZI_StatusVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZCHM_STATUS' )
{
  key value_low as Status,
      text      as Descricao
}
where
  language = $session.system_language
