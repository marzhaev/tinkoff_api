require "../spec_helper"

describe TinkoffApi::Webhooks::Operation do
  sample_operation = %Q({
      "operationId":"0b6c5905-2750-0052-bbf6-d9a566f2b4b1",
      "typeOfOperation":"Credit",
      "accountNumber":"40702810910000000000",
      "accountAmount":"65624",
      "accountCurrencyDigitalCode":"643",
      "status":"Active",
      "operationStatus":"transaction",
      "bic":"044525974",
      "category":"incomePeople",
      "documentNumber":"211",
      "operationAmount":"65624",
      "operationCurrencyDigitalCode":"643",
      "rubleAmount":"65624",
      "counterParty": {
        "account":"40702810840000000000",
        "bankBic":"044525225",
        "bankName":"ПАО Сбербанк",
        "corrAccount":"30101810400000000225",
        "inn":"5038000000",
        "kpp":"503801001",
        "name":"ООО \\"Плательщик\\""
      },
      "description":"Оплата по счету № 25-ъчэ-51 от 30.04.2025 за тмц Сумма 65624-00 В т.ч. НДС  (20%) 10937-33",
      "authorizationDate":"2025-05-14T06:55:42.495Z",
      "trxnPostDate":"2025-05-14T06:56:03Z",
      "payVo":"payment-order",
      "priority":"5",
      "cardNumber":"518901******0000",
      "ucid":"1025663161",
      "mcc":"0000",
      "merch": {
        "id":"TCS1",
        "city":"3010181040000",
        "country":"RU",
        "name":"Drugoy bank."
      },
      "acquirerId":"010455",
      "rrn":"0009LHLajhgH",
      "payPurpose":"Оплата по счету № 25-ъчэ-51 от 30.04.2025 за тмц Сумма 65624-00 В т.ч. НДС  (20%) 10937-33",
      "chargeDate":"2025-05-13T21:00:00Z",
      "drawDate":"2025-05-14T06:55:42Z",
      "receiver": {
        "account":"40702810910000000000",
        "name":"ООО \\"Получатель\\"",
        "inn":"5044000000",
        "kpp":"504701001",
        "bic":"044525974",
        "corrAccount":"30101810145250000974",
        "bankName":"АО \\"ТБанк\\""
      },
      "payer": {
        "account":"40702810840000000000",
        "name":"ООО \\"Плательщик\\"",
        "inn":"5038000000",
        "kpp":"503801001",
        "bic":"044525225",
        "corrAccount":"30101810400000000225",
        "bankName":"ПАО Сбербанк"
      },
      "docDate":"2025-05-13T21:00:00Z",
      "VO":"01"
    })

  it "parses operation" do
    operation = TinkoffApi::Webhooks::Operation.from_json(sample_operation)
    operation.operation_id.should eq("0b6c5905-2750-0052-bbf6-d9a566f2b4b1")
    operation.account_number.should eq("40702810910000000000")
    operation.account_amount.should eq("65624")
    operation.account_currency_digital_code.should eq("643")
  end
end