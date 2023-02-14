#language:ru
@test

Функционал: API тесты сервиса Weatherstack

  Структура сценария: Запрос в Weatherstack по городам
       # Генерится дандомная страка по маске
        # E - Английская буква,
        # R - русская буква,
        # D - цифра. Остальные символы игнорятся
        # Условна дана строка TEST_EEE_DDD_RRR - снегерится примерно такая - TEST_QRG_904_ЙЦУ
    * сгенерировать переменные
      | type             | City             |
      | query            | <city>,Russia    |
      | language         | en               |
      | unit             | m                |
      | name             | <city>           |
      | country          | Russia           |
      | lat              | DD.DDD           |
      | lon              | DD.DDD           |
      | timezone_id      | Europe/Moscow    |
      | localtime        | DDDD-DD-DD DD:DD |
      | localtime_epoch  | DDDDDDDDDD       |
      | utc_offset       | D.D              |
      | observation_time | DD:DD PM         |
      | weather_code     | DDD              |
      | weather_icons    | png              |
      | wind_speed       | DD               |
      | wind_degree      | DDD              |
      | wind_dir         | EEE              |
      | pressure         | DDD              |
      | precip           | D.D              |
      | humidity         | DD               |
      | cloudcover       | DD               |
      | feelslike        | D                |
      | uv_index         | D                |
      | visibility       | D                |
      | is_day           | no               |
    И создать запрос
      | method | url                                 |
      | GET    | http://api.weatherstack.com/current |
    И добавить query параметры
      | query      | <city>                           |
      | access_key | 676e8360aacd614fddd1dc56d19d7951 |

    Тогда отправить запрос
    И статус код 200

    И извлечь данные
      | response_type             | $.request.type             |
      | response_query            | $.request.query            |
      | response_language         | $.request.language         |
      | response_unit             | $.request.unit             |
      | response_name             | $.location.name            |
      | response_country          | $.location.country         |
      | response_location         | $.location.region          |
      | response_lat              | $.location.lat             |
      | response_lon              | $.location.lon             |
      | response_timezone_id      | $.location.timezone_id     |
      | response_localtime        | $.location.localtime      |
      | response_localtime_epoch  | $.location.localtime_epoch |
      | response_utc_offset       | $.location.utc_offset      |
      | response_observation_time | $.current.observation_time |
      | response_weather_code     | $.current.weather_code     |
      | response_weather_icons    | $.current.weather_icons    |
      | response_wind_speed       | $.current.wind_speed       |
      | response_wind_degree      | $.current.wind_degree      |
      | response_wind_dir         | $.current.wind_dir         |
      | response_pressure         | $.current.pressure         |
      | response_precip           | $.current.precip           |
      | response_humidity         | $.current.humidity         |
      | response_cloudcover       | $.current.cloudcover       |
      | response_feelslike        | $.current.feelslike        |
      | response_uv_index         | $.current.uv_index         |
      | response_visibility       | $.current.visibility       |
      | response_is_day           | $.current.is_day           |


    И сравнить значения
      | ${type}             | == | ${response_type}             |
      | ${query}            | == | ${response_query}            |
      | ${language}         | == | ${response_language}         |
      | ${unit}             | == | ${response_unit}             |
      | ${name}             | == | ${response_name}             |
      | ${country}          | == | ${response_country}          |
      | ${lat}              | == | ${response_lat}              |
      | ${lon}              | == | ${response_lon}              |
      | ${timezone_id}      | == | ${response_timezone_id}      |
      | ${localtime}        | == | ${response_localtime}        |
      | ${localtime_epoch}  | == | ${response_localtime_epoch}  |
      | ${utc_offset}       | == | ${response_utc_offset}       |
      | ${observation_time} | == | ${response_observation_time} |
      | ${weather_code}     | == | ${response_weather_code}     |
      | ${weather_icons}    | == | ${response_weather_icons}    |
      | ${wind_speed}       | == | ${response_wind_speed}       |
      | ${wind_degree}      | == | ${response_wind_degree}      |
      | ${wind_dir}         | == | ${response_wind_dir}         |
      | ${pressure}         | == | ${response_pressure}         |
      | ${precip}           | == | ${response_precip}           |
      | ${humidity}         | == | ${response_humidity}         |
      | ${cloudcover}       | == | ${response_cloudcover}       |
      | ${feelslike}        | == | ${response_feelslike}        |
      | ${uv_index}         | == | ${response_uv_index}         |
      | ${visibility}       | == | ${response_visibility}       |
      | ${is_day}           | == | ${response_is_day}           |

    И получить результат теста
    Примеры:
      | city   |
      | Moscow |
      | Orel   |
      | Omsk   |
      | London |

  Сценарий: Ошибка 101. Отсутствует токен(access_key)
    И создать запрос
      | method | url                                 |
      | GET    | http://api.weatherstack.com/current |
    И добавить query параметры
      | query | Moscow |

    Тогда отправить запрос
    И статус код 200
    Когда извлечь данные
      | response_success    | $.success    |
      | response_error_code | $.error.code |
      | response_type       | $.error.type |
      | response_info       | $.error.info |
    Тогда сравнить значения
      | false                                                                                  | == | ${response_success}    |
      | 101                                                                                    | == | ${response_error_code} |
      | missing_access_key                                                                     | == | ${response_type}       |
      | You have not supplied an API Access Key. [Required format: access_key=YOUR_ACCESS_KEY] | == | ${response_info}       |
    И получить результат теста

  Сценарий: Ошибка 101. Неверный токен(access_key)
    И создать запрос
      | method | url                                 |
      | GET    | http://api.weatherstack.com/current |
    И добавить query параметры
      | query      | Moscow                             |
      | access_key | 676e8360aacd614fddd1dc56d19d795111 |

    Тогда отправить запрос
    И статус код 200
    Когда извлечь данные
      | response_success    | $.success    |
      | response_error_code | $.error.code |
      | response_type       | $.error.type |
      | response_info       | $.error.info |
    Тогда сравнить значения
      | false                                                                                   | == | ${response_success}    |
      | 101                                                                                     | == | ${response_error_code} |
      | invalid_access_key                                                                      | == | ${response_type}       |
      | You have not supplied a valid API Access Key. [Technical Support: support@apilayer.com] | == | ${response_info}       |
    И получить результат теста

  Сценарий: Ошибка 103. Неверный API запрос
    И создать запрос
      | method | url                                |
      | GET    | http://api.weatherstack.com/privet |
    И добавить query параметры
      | query      | Moscow                           |
      | access_key | 676e8360aacd614fddd1dc56d19d7951 |

    Тогда отправить запрос
    И статус код 200
    Когда извлечь данные
      | response_success    | $.success    |
      | response_error_code | $.error.code |
      | response_type       | $.error.type |
      | response_info       | $.error.info |
    Тогда сравнить значения
      | false                             | == | ${response_success}    |
      | 103                               | == | ${response_error_code} |
      | invalid_api_function              | == | ${response_type}       |
      | This API Function does not exist. | == | ${response_info}       |
    И получить результат теста


  Сценарий: Ошибка 105. Подписка данного пользователя не поддерживает HTTPS
    И создать запрос
      | method | url                                  |
      | GET    | https://api.weatherstack.com/current |
    И добавить query параметры
      | query      | Moscow                           |
      | access_key | 676e8360aacd614fddd1dc56d19d7951 |

    Тогда отправить запрос
    И статус код 200
    Когда извлечь данные
      | response_success    | $.success    |
      | response_error_code | $.error.code |
      | response_type       | $.error.type |
      | response_info       | $.error.info |
    Тогда сравнить значения
      | false                                                                                 | == | ${response_success}    |
      | 105                                                                                   | == | ${response_error_code} |
      | https_access_restricted                                                               | == | ${response_type}       |
      | Access Restricted - Your current Subscription Plan does not support HTTPS Encryption. | == | ${response_info}       |
    И получить результат теста