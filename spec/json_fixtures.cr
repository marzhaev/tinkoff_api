module JSON_FIXTURES
  CREDIT_TRANSACTION = <<-JSON
    {"operationId":"bdfbd8be-6d5d-0064-8f7f-912644cad4bb","typeOfOperation":"Credit","accountNumber":"40702810910000045892","accountAmount":"19588.49","accountCurrencyDigitalCode":"643","status":"Active","operationStatus":"transaction","bic":"044525974","category":"incomePeople","documentNumber":"267","operationAmount":"19588.49","operationCurrencyDigitalCode":"643","rubleAmount":"19588.49","counterParty":{"account":"40702810110001754490","bankBic":"044525974","bankName":"АО ТБАНК г. Москва","corrAccount":"30101810145250000974","inn":"5012073362","kpp":"501201001","name":"ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ СОЛ ГРУПП"},"description":"Оплата по счету № 25-фжр-13 от 31.03.2025 за электротехническую продукцию Сумма 19588-49 В т.ч. НДС  (20%) 3264-75","authorizationDate":"2025-03-31T15:07:40Z","trxnPostDate":"2025-03-31T15:08:55Z","payVo":"payment-order","priority":"0","cardNumber":"518901******0294","ucid":"1025663161","mcc":"0000","merch":{"id":"TCS1"},"acquirerId":"999999","rrn":"007571504414","payPurpose":"Оплата по счету № 25-фжр-13 от 31.03.2025 за электротехническую продукцию Сумма 19588-49 В т.ч. НДС  (20%) 3264-75","chargeDate":"2025-03-30T21:00:00Z","drawDate":"2025-03-31T15:08:01Z","receiver":{"account":"40702810910000045892","name":"ООО ТЭКСЭНЕРГО ЭЛЕКТРИК","inn":"5044082271","kpp":"504701001","bic":"044525974","corrAccount":"30101810145250000974","bankName":"АО ТБанк"},"payer":{"account":"40702810110001754490","name":"ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ СОЛ ГРУПП","inn":"5012073362","kpp":"501201001","bic":"044525974","corrAccount":"30101810145250000974","bankName":"АО ТБанк"},"docDate":"2025-03-30T21:00:00Z","VO":"01"}
  JSON

  DEBIT_TRANSACTION = <<-JSON
    {"operationId":"73c53955-292a-009e-955b-d0e8122894d9","typeOfOperation":"Debit","accountNumber":"40702810910000045892","accountAmount":"29","accountCurrencyDigitalCode":"643","status":"Active","operationStatus":"transaction","bic":"044525974","category":"fee","documentNumber":"298462","operationAmount":"29","operationCurrencyDigitalCode":"643","rubleAmount":"29","counterParty":{"account":"70601810600002740204","bankBic":"044525974","corrAccount":"30101810145250000974","inn":"7710140679","kpp":"771301001","name":"АО ТБанк"},"description":"Комиссия за внешний банковский перевод","authorizationDate":"2025-03-31T06:36:18Z","trxnPostDate":"2025-03-31T06:37:39Z","payVo":"bank-order","cardNumber":"518901******0294","ucid":"1025663161","mcc":"0010","merch":{"id":"SME","city":"MOSCOW","country":"RUS","name":"АО ТБанк"},"acquirerId":"999999","payPurpose":"Комиссия за внешний банковский перевод. Договор 7000899232","drawDate":"2025-03-31T14:52:29Z","receiver":{"account":"70601810600002740204","name":"АО ТБанк","inn":"7710140679","kpp":"771301001","bic":"044525974","corrAccount":"30101810145250000974","bankName":"АО ТБанк"},"payer":{"account":"40702810910000045892","name":"ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ ТЭКСЭНЕРГО ЭЛЕКТРИК","inn":"5044082271","bic":"044525974","corrAccount":"30101810145250000974","bankName":"АО ТБанк"},"docDate":"2025-03-30T21:00:00Z","VO":"17"}
  JSON

  LOAN_RETURN_TRANSACTION = <<-JSON
    {"operationId":"1fd66ca4-47ac-00d7-8df6-06eef0da23dd","typeOfOperation":"Credit","accountNumber":"40702810910000045892","accountAmount":"200000","accountCurrencyDigitalCode":"643","status":"Active","operationStatus":"transaction","bic":"044525974","category":"incomePeople","documentNumber":"203","operationAmount":"200000","operationCurrencyDigitalCode":"643","rubleAmount":"200000","counterParty":{"account":"40702810638000481807","bankBic":"044525225","bankName":"ПАО Сбербанк","corrAccount":"30101810400000000225","inn":"9722055157","name":"ООО ПКФ КРИСТАЛЛ"},"description":"Частичный возврат займа по договору №2 от 04.09.2024 г.Сумма 200000-00Без налога (НДС)","authorizationDate":"2025-03-31T14:50:13Z","trxnPostDate":"2025-03-31T14:50:26Z","payVo":"payment-order","priority":"5","cardNumber":"518901******0294","ucid":"1025663161","mcc":"0000","merch":{"id":"TCS1"},"acquirerId":"010455","rrn":"0009WdZGhkfh","payPurpose":"Частичный возврат займа по договору №2 от 04.09.2024 г.Сумма 200000-00Без налога (НДС)","chargeDate":"2025-03-30T21:00:00Z","drawDate":"2025-03-31T14:50:19Z","receiver":{"account":"40702810910000045892","name":"ООО ТЭКСЭНЕРГО ЭЛЕКТРИК","inn":"5044082271","bic":"044525974","corrAccount":"30101810145250000974","bankName":"АО ТБанк"},"payer":{"account":"40702810638000481807","name":"ООО ПКФ КРИСТАЛЛ","inn":"9722055157","bic":"044525225","corrAccount":"30101810400000000225","bankName":"ПАО Сбербанк"},"docDate":"2025-03-30T21:00:00Z","VO":"01"}
  JSON

  DEBIT_TRANSACTION_WITHOUT_RUBLE_AMOUNT = <<-JSON
    {"operationId":"8b2fe732-db35-00da-a6bb-6b80e513bf36","typeOfOperation":"Debit","accountNumber":"40702810910000045892","accountAmount":"20160","accountCurrencyDigitalCode":"643","status":"Active","operationStatus":"transaction","bic":"044525974","category":"contragentPeople","documentNumber":"141","operationAmount":"20160","operationCurrencyDigitalCode":"643","counterParty":{"account":"40702810901600006867","bankBic":"044525593","bankName":"АО \\"АЛЬФА-БАНК\\"","corrAccount":"30101810200000000593","inn":"7715215141","kpp":"504401001","name":"ООО \\"МФК Техэнерго\\""},"description":"Оплата по договору аренды №Т1/21/05-1901 от 19.05.2021. В т.ч. НДС 20% — 3 360 руб","authorizationDate":"2025-04-01T13:42:09Z","trxnPostDate":"2025-04-01T13:44:15Z","priority":"5","cardNumber":"518901******0294","ucid":"1025663161","mcc":"0010","merch":{"id":"SME","city":"MOSCOW","country":"RUS","name":"TBank.Kontragent"},"acquirerId":"999999","rrn":"007572537773"}
  JSON

  def self.[](key : String) : String
    case key
    when "credit_transaction"
      CREDIT_TRANSACTION
    when "debit_transaction"
      DEBIT_TRANSACTION
    when "loan_return_transaction"
      LOAN_RETURN_TRANSACTION
    when "debit_transaction_without_ruble_amount"
      DEBIT_TRANSACTION_WITHOUT_RUBLE_AMOUNT
    else
      raise "Unknown fixture key: #{key}"
    end
  end
end 