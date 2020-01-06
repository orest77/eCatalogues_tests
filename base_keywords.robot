*** Settings ***
Library  Collections
Resource  client/keywords_api.robot
Resource  data/keywords_data.robot


*** Keywords ***
Можливість cтворити критерію
  [Arguments]  ${user_name}
  ${CRITERIA_DATA}  Піготувати дані для критерії
  Set Suite Variable  ${CRITERIA_DATA}
  ${RESPONSE}  Створити критерію  ${CRITERIA_DATA}  ${user_name}
  Set Suite Variable  ${ID_CRITERIA}  ${RESPONSE}
  [Return]  ${RESPONSE}

Можливість переглядати список критеріїв
  [Arguments]  ${user_name}
  ${GET_RESPONSE}  Переглядати список критеріїв  ${user_name}
  log  ${GET_RESPONSE}
  Log Variables
  [Return]  ${GET_RESPONSE}

Можливість переглядати критерію по ідентифікатору
  [Arguments]  ${user_name}
  ${GET_RESPONSE_BY_ID}  Переглядати критерію  ${ID_CRITERIA}  ${user_name}
  log  ${GET_RESPONSE_BY_ID}
  Log Variables
  [Return]  ${GET_RESPONSE_BY_ID}

Можливість змінити критерію
  [Arguments]  ${user_name}
  ${EDIT_DATA}  Підготувати дані для редагування
  Set Suite Variable  ${EDIT_DATA}
  ${PATCH_RESPONSE}  Змінити критерію  ${ID_CRITERIA}  ${EDIT_DATA}  ${user_name}
  log  ${PATCH_RESPONSE}
  set suite variable  ${PATCH_RESPONSE}
  [Return]  ${PATCH_RESPONSE}

Можливість видаляти критерію
  [Arguments]  ${user_name}
  ${RESPONSE}  Видаляти критерію  ${ID_CRITERIA}  ${user_name}
  log  ${RESPONSE}
  Log Variables
  [Return]  ${RESPONSE}

Можливість переглядати статус критерій
  [Arguments]  ${user_name}  ${status_url}
  ${GET_RESPONSE}  Переглянути статус критерій  ${status_url}  ${user_name}
  log  ${GET_RESPONSE}
  Log Variables
  [Return]  ${GET_RESPONSE}

Можливість змінити статус критерії
  [Arguments]  ${user_name}  ${status}
  ${STATUS_DATA}  Підготувати дані для редагування
  set to dictionary  ${STATUS_DATA}  status=${status}
  set suite variable  ${STATUS_DATA}
  ${PATCH_RESPONSE}  Змінити критерію  ${ID_CRITERIA}  ${STATUS_DATA}  ${user_name}
  log  ${PATCH_RESPONSE}
  set suite variable  ${PATCH_RESPONSE}
  [Return]  ${PATCH_RESPONSE}

#################################################
########Перевірки для критерії##################
###############################################

#
Перевірити чи критерія появилася в статусі
  [Arguments]  ${user_name}  ${status_path}
  ${get_status_criteria}  Можливість переглядати статус критерій  ${user_name}  ${status_path}
  Перевірити присутність критерії по статусу  ${get_status_criteria}  ${ID_CRITERIA}

Перевірити критерію на зміну статусу
  [Arguments]  ${user_name}  ${status}
  ${get_status_criteria}  Можливість змінити статус критерії  ${user_name}  ${status}
  log  ${get_status_criteria}
  Порівнняти відредаговані дані  ${get_status_criteria}  ${STATUS_DATA}

#########
Перевірка цілісності даних критерії при змінювані статусу
  [Arguments]  ${user_name}
  ${get_criteria}  Можливість переглядати критерію по ідентифікатору  ${user_name}
  ${responses}  create dictionary
  ${STATUS_DATA_RETIRED}  Підготувати дані для редагування
  set to dictionary  ${STATUS_DATA_RETIRED}  status=retired
  Змінити критерію  ${get_criteria.id}  ${STATUS_DATA_RETIRED}  admin
  ${GET_RESPONSE_RETIRED}  Переглядати критерію  ${get_criteria.id}  ${user_name}
  set to dictionary  ${responses}  first=${GET_RESPONSE_RETIRED}
  set to dictionary  ${STATUS_DATA_RETIRED}  status=active
  Змінити критерію  ${get_criteria.id}  ${STATUS_DATA_RETIRED}  admin
  ${GET_RESPONSE_ACTIVE}  Переглядати критерію  ${get_criteria.id}  ${user_name}
  set to dictionary  ${responses}  second=${GET_RESPONSE_ACTIVE}
  Перевірити цілісність критерій  ${responses.first}  ${responses.second}
#########

Перевірити створену критерію по ідентифікатору
  [Arguments]  ${user_name}
  ${get_criteria}  Можливість переглядати критерію по ідентифікатору  ${user_name}
  Порівняти дані критерії  ${get_criteria}  ${CRITERIA_DATA}

Перевірити редагування критерії
  [Arguments]  ${user_name}
  ${get_criteria}  Можливість переглядати критерію по ідентифікатору  ${user_name}
  Порівнняти відредаговані дані  ${get_criteria}  ${EDIT_DATA}

Перевірити список критерій
  [Arguments]  ${user_name}
  ${get_griteries}  Можливість переглядати список критеріїв  ${user_name}
  Звірити всі критерії з підрахунком  ${get_griteries}

Перевірити відсутність доступу користувача до створення критерії
  [Arguments]  ${user_name}
  ${create_criteria}  Run Keyword And Expect Error  *  Можливість cтворити критерію  ${user_name}
  ${expected_result}  convert to string  You do not have permission to perform this action.
  Звірити повідомення про помилку  ${create_criteria}  ${expected_result}

Перевірити відсутність доступу користувача до можливості змінити критерію
  [Arguments]  ${user_name}
  ${create_criteria}  Run Keyword And Expect Error  *  Можливість змінити критерію  ${user_name}
  ${expected_result}  convert to string  You do not have permission to perform this action.
  Звірити повідомення про помилку  ${create_criteria}  ${expected_result}

Перевірити відсутність доступу користувача до видалення критерії
  [Arguments]  ${user_name}
  ${create_criteria}  Run Keyword And Expect Error  *  Можливість видаляти критерію  ${user_name}
  ${expected_result}  convert to string  You do not have permission to perform this action.
  Звірити повідомення про помилку  ${create_criteria}  ${expected_result}

Перевірити чи критерія видалена
  [Arguments]  ${user_name}
  ${get_criteria}  Можливість переглядати критерію по ідентифікатору  ${user_name}
  log  ${get_criteria.status}
  Перевірити статус критерії  ${get_criteria}

Перевірити відсутність можливості створити критерію з некоректним ід-кодом в класифікації
  [Arguments]  ${user_name}  ${invalid_id}
  ${ARRANGE_DATA}  Піготувати дані для критерії
  set to dictionary  ${ARRANGE_DATA.classification}  id=${invalid_id}
  ${create_criteria}  Run Keyword And Expect Error  *  Створити критерію  ${ARRANGE_DATA}  ${user_name}
  log  ${create_criteria}
  ${lenght_id}   get length  ${invalid_id}
  Run Keyword If    ${lenght_id} == 10    Звірити повідомення про помилку  ${create_criteria}  Wrong id
  ...  ELSE IF  ${lenght_id} < 10  Звірити повідомення про помилку  ${create_criteria}  Enter a valid value.
  ...  ELSE IF  ${lenght_id} > 10    Звірити повідомення про помилку  ${create_criteria}  Ensure this field has no more than 10 characters.

Перевірити відсутність можливості створити критерію з некоректним даними в допоміжній класифікації
  [Arguments]  ${user_name}  ${string_name}  ${invalid_data}
  ${ARRANGE_DATA}  Піготувати дані для критерії
  set to dictionary  ${ARRANGE_DATA.additionalClassification}  ${string_name}=${invalid_data}
  ${lenght_id}  get length  ${invalid_data}
  ${create_criteria}  Run Keyword And Expect Error  *   Створити критерію  ${ARRANGE_DATA}  ${user_name}
  run keyword if  '${string_name}' == 'id' and ${lenght_id} > 10   Звірити повідомення про помилку  ${create_criteria}  Ensure this field has no more than 10 characters.
  ...  ELSE IF  '${string_name}' == 'id' and ${lenght_id} < 10    Звірити повідомення про помилку  ${create_criteria}  Wrong id
  ...  ELSE IF  '${string_name}' == 'scheme'  Звірити повідомення про помилку  ${create_criteria}  Unknown scheme

Перевірити відсутність можливості змінити масимальне значення менше від мінімального
  [Arguments]  ${user_name}  ${min}  ${max}
  ${ARRANGE_DATA}  Піготувати дані для критерії
  set to dictionary  ${ARRANGE_DATA}  minValue=${min}
  set to dictionary  ${ARRANGE_DATA}  maxValue=${max}
  ${create_criteria}  Run Keyword And Expect Error  *   Створити критерію  ${ARRANGE_DATA}  ${user_name}
  Звірити повідомення про помилку  ${create_criteria}  minValue can`t be greater than maxValue

Перевірити відсутність можливості змінити на некоректну одиницю виміру
  [Arguments]  ${user_name}  ${invalid_unit}
  ${ARRANGE_DATA}  Піготувати дані для критерії
  set to dictionary  ${ARRANGE_DATA.unit}  code=${invalid_unit}
  ${create_criteria}  Run Keyword And Expect Error  *   Створити критерію  ${ARRANGE_DATA}  ${user_name}
  Звірити повідомення про помилку  ${create_criteria}  Wrong code

Перевірити авто допис при некоректному вводі данних
  [Arguments]  ${user_name}  ${classification}  ${invalid_data}
  ${ARRANGE_DATA}  Піготувати дані для критерії
  ${actual_data}  Get From Dictionary  ${ARRANGE_DATA.${classification}}  description
  set to dictionary  ${ARRANGE_DATA.${classification}}  description=${invalid_data}
  ${create_criteria}  Створити критерію для перевірки  ${ARRANGE_DATA}  ${user_name}
  should be equal  ${create_criteria.${classification}.description}  ${actual_data}
  should not be equal  ${create_criteria.${classification}.description}  ${ARRANGE_DATA.${classification}.description}

##################
#####ASSERT######
################

Перевірити цілісність критерій
  [Arguments]  ${first}  ${second}
  should not be equal  ${first.dateModified}  ${second.dateModified}  msg=dateModified are equal
  should be equal  ${first.status}  retired  msg=status are not retited
  should be equal  ${second.status}  active  msg=status are not active
  remove from dictionary  ${first}  status
  remove from dictionary  ${first}  dateModified
  remove from dictionary  ${second}  status
  remove from dictionary  ${second}  dateModified
  log  ${first}
  log  ${second}
  should be equal  ${first}  ${second}  msg=DATA without status and dateModified are not equal

Перевірити статус критерії
  [Arguments]  ${actual_result}
  should be equal  ${actual_result.status}  retired

Перевірити присутність критерії по статусу
  [Arguments]  ${actual_result}  ${expected_result}
  ${index}  convert to integer  0
  ${actual}  convert to boolean  0
  :FOR  ${result}  IN  ${actual_result.results}
  \  ${actual}=  exit for loop if  '${actual_result.results[${index}].id}' == '${expected_result}'
  \  ${index}  ${index + 1}
  log  ${actual}
  should be true  ${actual}


Звірити повідомення про помилку
  [Arguments]  ${actual_result}  ${expeted_result}
  should contain  ${actual_result}  ${expeted_result}  msg=Objects are not contain


Звірити всі критерії з підрахунком
  [Arguments]  ${actual_result}
  ${expected}  get variable value  ${actual_result.count}
  ${actual}  get length  ${actual_result.results}
  log  ${actual}
  should be equal  ${actual}  ${actual}

Порівняти дані критерії
  [Arguments]  ${actual_resul}  ${expected_result}
  log  ${actual_resul}
  log  ${expected_result}
  remove from dictionary  ${actual_resul}  id
  remove from dictionary  ${actual_resul}  status
  remove from dictionary  ${actual_resul}  dateModified
  dictionaries should be equal  ${actual_resul}  ${expected_result}  msg=Objects are not equal

Порівнняти відредаговані дані
  [Arguments]  ${actual_resul}  ${expected_result}
  log  ${actual_resul}
  log  ${expected_result}
  should be equal  ${actual_resul.name}  ${expected_result.name}  msg=Objects NAME are not equal
  should be equal  ${actual_resul.nameEng}  ${expected_result.nameEng}  msg=Objects NAME_ENG are not equal
  should be equal  ${actual_resul.minValue}  ${expected_result.minValue}  msg=Objects MIN_VALUE are not equal
  should be equal  ${actual_resul.maxValue}  ${expected_result.maxValue}  msg=Objects MAX_VALUE are not equal
  should be equal  ${actual_resul.status}  ${expected_result.status}  msg=Objects STATUS are not equal


