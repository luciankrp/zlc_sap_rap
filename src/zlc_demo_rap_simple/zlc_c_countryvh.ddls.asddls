@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search help for country'
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZLC_C_CountryVH
  as select from I_Country
{
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element: [ 'Description' ]
  key Country,
      @Search.defaultSearchElement: true
      @Search.ranking: #LOW
      @Search.fuzzinessThreshold: 0.8
      _Text[1: Language = $session.system_language ].CountryName as Description
}
