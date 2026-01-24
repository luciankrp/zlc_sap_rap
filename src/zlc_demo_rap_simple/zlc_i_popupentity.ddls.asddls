@EndUserText.label: 'Entity for popup'
define abstract entity ZLC_I_PopupEntity
{
  @Consumption.valueHelpDefinition: [{ entity: {
      name      : 'ZLC_C_CountryVH',
      element   : 'Country'
  } }]
  @EndUserText.label: 'Country'
  SearchCountry : land1;
  @EndUserText.label: 'New date'
  NewDate       : abap.dats;
  @EndUserText.label: 'Message type'
  MessageType   : abap.int4;
  @EndUserText.label: 'Update data'
  FlagUpdate    : abap.char(1);
  @EndUserText.label: 'Show Messages'
  FlagMessage   : abap_boolean;
}
