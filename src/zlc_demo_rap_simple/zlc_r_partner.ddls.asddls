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
      local_created_by      as LocalCreatedBy,
      local_created_at      as LocalCreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt
}
