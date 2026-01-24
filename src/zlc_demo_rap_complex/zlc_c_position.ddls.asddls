@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Position'
define view entity ZLC_C_POSITION
  as projection on ZLC_I_Position
{
  key Document,
  key PositionNumber,
      Material,
      Quantity,
      Unit,
      Price,
      Currency,

      /* Associations */
      _Invoice : redirected to parent ZLC_C_INVOICE
}
