@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Material'
define view entity ZLC_I_Material
  as select from zlc_dmo_material
{
  key material       as Material,
      name           as MaterialName,
      description    as Description,
      stock          as Stock,
      stock_unit     as StockUnit,
      price_per_unit as PricePerUnit,
      currency       as Currency
}
