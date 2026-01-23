@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Partner Consumption View'
@Metadata.allowExtensions: true
define root view entity ZLC_C_PARTNER
  provider contract transactional_query
  as projection on ZLC_R_PARTNER
{
  key PartnerNumber,
      PartnerName,
      Street,
      City,
      Country,
      PaymentCurrency,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
