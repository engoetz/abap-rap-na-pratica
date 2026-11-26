@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ajuda de pesquisa de clientes'
define view entity ZI_ClienteVH
  as select from I_Customer
{
  key Customer     as Cliente,
      CustomerName as Nome
}
