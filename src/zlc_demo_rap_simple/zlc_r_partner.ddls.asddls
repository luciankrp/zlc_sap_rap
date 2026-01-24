@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Partner Base/Root View Entity'
define root view entity ZLC_R_PARTNER
  as select from zlc_dmo_partner as Partner
{
  key partner               as PartnerNumber,
      name                  as PartnerName,
      street                as Street,
      city                  as City,
      country               as Country,
      payment_currency      as PaymentCurrency,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt
}
