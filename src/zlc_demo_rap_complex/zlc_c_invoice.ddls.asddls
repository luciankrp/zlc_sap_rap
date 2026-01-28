@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Consumption for Invoice'

@Metadata.allowExtensions: true

@Search.searchable: true

define root view entity ZLC_C_INVOICE
  provider contract transactional_query
  as projection on ZLC_R_Invoice

{
          @Search.defaultSearchElement: true
          @Search.fuzzinessThreshold: 1.0
  key     Document,

          DocDate,
          DocTime,

          @Search.defaultSearchElement: true
          @Search.fuzzinessThreshold: 0.9
          Partner,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LC_DEMO_VE_EXIT'
  virtual NumberOfPositions : abap.int4,

          /* Associations */
          _Position : redirected to composition child ZLC_C_POSITION
}
