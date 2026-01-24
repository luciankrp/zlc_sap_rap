@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Base/Root View'
define root view entity ZLC_R_Invoice
  as select from zlc_dmo_invoice
  composition [*] of ZLC_I_Position as _Position
{
  key document as Document,
      doc_date as DocDate,
      doc_time as DocTime,
      partner  as Partner,

      //* Associations *//
      _Position
}
