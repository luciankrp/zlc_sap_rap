@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Position'
define view entity ZLC_I_Position
  as select from zlc_dmo_position

  association     to parent ZLC_R_Invoice as _Invoice  on $projection.Document = _Invoice.Document

  association [1] to ZLC_I_Material       as _Material on $projection.Material = _Material.Material
{
  key document            as Document,
  key pos_number          as PositionNumber,
      material            as Material,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity            as Quantity,
      _Material.StockUnit as Unit,
      price               as Price,
      currency            as Currency,

      //* Associations *//
      _Invoice
}
