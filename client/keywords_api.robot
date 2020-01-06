*** Settings ***
Library  client.client_helper
Library  service_keywords
Library  String
Library  Collections
Library  OperatingSystem
Library  DateTime
Resource  resource.robot

*** Keywords ***
Підготувати клієнт для користувача
  ${USERS}  load_data_from  users.yaml
  :FOR  ${username}  IN  @{USED_ROLES}
  \  ${api_wraper}  prepare api wrapper  ${USERS.users.${username}.user_name}  ${USERS.users.${username}.api_key}  ${API_HOST_URL}  ${API_VERSION}
  \  set to dictionary  ${USERS.users.${username}}  client=${api_wraper}
  set suite variable  ${USERS}

Створити критерію
  [Arguments]  ${DATA}  ${username}
  ${RESPONSE}  call method  ${USERS.users.${username}.client}  create_criteria  ${RESOURCE}  ${DATA}
  log  ${RESPONSE}
  Log Variables
  [Return]  ${RESPONSE.id}

Переглядати список критеріїв
  [Arguments]  ${username}
  ${RESPONSE}  call method  ${USERS.users.${username}.client}  get_criteria  ${RESOURCE}
  log  ${RESPONSE}
  Log Variables
  [Return]  ${RESPONSE}

Переглядати критерію
  [Arguments]  ${ID}  ${username}
  ${RESPONSE}  call method  ${USERS.users.${username}.client}  get_criteria  ${RESOURCE}  ${ID}
  log  ${RESPONSE}
  Log Variables
  [Return]  ${RESPONSE}


Змінити критерію
  [Arguments]  ${ID}  ${EDIT_DATA}  ${username}
  ${RESPONSE}  call method  ${USERS.users.${username}.client}  update_criteria  ${ID}  ${RESOURCE}  ${EDIT_DATA}
  log  ${RESPONSE}
  Log Variables
  [Return]  ${RESPONSE}

Видаляти критерію
  [Arguments]  ${ID}  ${username}
  ${RESPONSE}  call method  ${USERS.users.${username}.client}  delete_criteria  ${ID}  ${RESOURCE}
  log  ${RESPONSE}
  Log Variables
  [Return]  ${RESPONSE}

Переглянути статус критерій
  [Arguments]  ${STATUS}  ${username}
  ${RESPONSE}  call method  ${USERS.users.${username}.client}  get_status  ${RESOURCE}  ${STATUS}
  log  ${RESPONSE}
  Log Variables
  [Return]  ${RESPONSE}

Створити критерію для перевірки
  [Arguments]  ${DATA}  ${username}
  ${RESPONSE}  call method  ${USERS.users.${username}.client}  create_criteria  ${RESOURCE}  ${DATA}
  log  ${RESPONSE}
  Log Variables
  [Return]  ${RESPONSE}