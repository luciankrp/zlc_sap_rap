@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Unmanaged Root'

define root view entity ZLC_R_DMOUnmanaged
  as select from zlc_dmo_unmgnd

{
  key gen_key as TableKey,

      text    as Description,
      cdate   as CreationDate
}
