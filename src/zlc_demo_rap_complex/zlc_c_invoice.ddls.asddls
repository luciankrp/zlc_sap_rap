@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Invoice'
define root view entity ZLC_C_INVOICE
 provider contract transactional_query
  as projection on ZLC_R_Invoice
{
  key Document,
      DocDate,
      DocTime,
      Partner,
      
      /* Associations */
      _Position : redirected to composition child ZLC_C_POSITION
}
