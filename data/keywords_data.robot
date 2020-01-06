*** Settings ***
Library  data.init_data

*** Keywords ***
Піготувати дані для критерії
  ${CRITERIA_DATA}  data_for_criteria  ДК021
  log  ${CRITERIA_DATA}
  [Return]  ${CRITERIA_DATA}

Підготувати дані для редагування
  ${EDIT_DATA}  data_for_edit
  log  ${EDIT_DATA}
  [Return]  ${EDIT_DATA}