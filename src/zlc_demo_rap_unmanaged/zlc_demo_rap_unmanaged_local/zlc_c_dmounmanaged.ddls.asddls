@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Unmanaged Consumption/Projection'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_LC_DEMO_UNMANAGED_QUERY'

@UI.headerInfo: { typeName: 'Unmanaged', typeNamePlural: 'Unmanaged', title.value: 'Description' }

define root view entity ZLC_C_DMOUnmanaged
provider contract transactional_query
  as projection on ZLC_R_DMOUnmanaged

{
      @UI.facet: [ { id: 'FacetData', label: 'Data', type: #FIELDGROUP_REFERENCE, targetQualifier: 'DATA' } ]
      @UI.fieldGroup: [ { position: 10, label: 'Key' } ]
      @UI.lineItem: [ { position: 10, label: 'Key' } ]
  key TableKey,

      @UI.fieldGroup: [ { position: 20, label: 'Description', qualifier: 'DATA' } ]
      @UI.lineItem: [ { position: 20, label: 'Text' } ]
      @UI.selectionField: [ { position: 10 } ]
//      @EndUserText.label: 'Text'
      Description,

      @UI.fieldGroup: [ { position: 20, label: 'Created at', qualifier: 'DATA' } ]
      @UI.lineItem: [ { position: 30, label: 'Created at' } ]
      @UI.selectionField: [ { position: 20 } ]
//      @EndUserText.label: 'Created at'
      CreationDate
}
