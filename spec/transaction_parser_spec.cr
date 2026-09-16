require "./spec_helper"
require "./json_fixtures"

describe TinkoffApi::Webhooks::Operation do
  it "parses credit transaction correctly" do
    json = JSON_FIXTURES["credit_transaction"]
    operation = TinkoffApi::Webhooks::Operation.parse_transactions(json)

    operation.operation_id.should eq "bdfbd8be-6d5d-0064-8f7f-912644cad4bb"
    operation.type_of_operation.should eq TinkoffApi::Webhooks::Operation::OperationType::Credit
    operation.account_number.should eq "40702810910000045892"
    operation.account_amount.should eq "19588.49"
    operation.operation_amount.should eq "19588.49"
    operation.description.should eq "Оплата по счету № 25-фжр-13 от 31.03.2025 за электротехническую продукцию Сумма 19588-49 В т.ч. НДС  (20%) 3264-75"
    operation.authorization_date.should eq Time.parse_rfc3339("2025-03-31T15:07:40Z")
    operation.trxn_post_date.should eq Time.parse_rfc3339("2025-03-31T15:08:55Z")
    operation.draw_date.should eq Time.parse_rfc3339("2025-03-31T15:08:01Z")
    
    # Test counter party
    counter_party = operation.counter_party.not_nil!
    counter_party.account.should eq "40702810110001754490"
    counter_party.name.should eq "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ СОЛ ГРУПП"
    counter_party.inn.should eq "5012073362"
    
    # Test merchant
    operation.merch.not_nil!.id.should eq "TCS1"
    
    # Test receiver
    operation.receiver.try(&.name).should eq "ООО ТЭКСЭНЕРГО ЭЛЕКТРИК"
    operation.receiver.try(&.inn).should eq "5044082271"
  end

  it "parses debit transaction correctly" do
    json = JSON_FIXTURES["debit_transaction"]
    operation = TinkoffApi::Webhooks::Operation.parse_transactions(json)

    operation.operation_id.should eq "73c53955-292a-009e-955b-d0e8122894d9"
    operation.type_of_operation.should eq TinkoffApi::Webhooks::Operation::OperationType::Debit
    operation.account_number.should eq "40702810910000045892"
    operation.account_amount.should eq "29"
    operation.operation_amount.should eq "29"
    operation.description.should eq "Комиссия за внешний банковский перевод"
    
    # Test counter party
    counter_party = operation.counter_party.not_nil!
    counter_party.account.should eq "70601810600002740204"
    counter_party.name.should eq "АО ТБанк"
    counter_party.inn.should eq "7710140679"
    
    # Test merchant
    merch = operation.merch.not_nil!
    merch.id.should eq "SME"
    merch.city.should eq "MOSCOW"
    merch.country.should eq "RUS"
    merch.name.should eq "АО ТБанк"
  end

  it "parses loan return transaction correctly" do
    json = JSON_FIXTURES["loan_return_transaction"]
    operation = TinkoffApi::Webhooks::Operation.parse_transactions(json)

    operation.operation_id.should eq "1fd66ca4-47ac-00d7-8df6-06eef0da23dd"
    operation.type_of_operation.should eq TinkoffApi::Webhooks::Operation::OperationType::Credit
    operation.account_number.should eq "40702810910000045892"
    operation.account_amount.should eq "200000"
    operation.operation_amount.should eq "200000"
    operation.description.should eq "Частичный возврат займа по договору №2 от 04.09.2024 г.Сумма 200000-00Без налога (НДС)"
    
    # Test counter party
    counter_party = operation.counter_party.not_nil!
    counter_party.account.should eq "40702810638000481807"
    counter_party.name.should eq "ООО ПКФ КРИСТАЛЛ"
    counter_party.inn.should eq "9722055157"
    counter_party.bank_name.should eq "ПАО Сбербанк"
    
    # Test merchant
    operation.merch.not_nil!.id.should eq "TCS1"
  end

  it "parses debit transaction without ruble amount correctly" do
    json = JSON_FIXTURES["debit_transaction_without_ruble_amount"]
    operation = TinkoffApi::Webhooks::Operation.parse_transactions(json)

    operation.operation_id.should eq "8b2fe732-db35-00da-a6bb-6b80e513bf36"
    operation.type_of_operation.should eq TinkoffApi::Webhooks::Operation::OperationType::Debit
  end

  it "parses transaction without merch and acquirerId" do
    json = JSON_FIXTURES["credit_transaction_without_merch"]
    operation = TinkoffApi::Webhooks::Operation.parse_transactions(json)

    operation.operation_id.should eq "bdfbd8be-6d5d-0064-8f7f-912644cad4bb"
    operation.merch.should be_nil
    operation.acquirer_id.should be_nil
  end

  it "parses payload with only required fields" do
    json = %({
      "operationId":"64be58f9-c7fc-0027-96ba-763ec56a2317",
      "accountNumber":"40702810510000710417",
      "typeOfOperation":"Credit",
      "accountAmount":"500.01",
      "accountCurrencyDigitalCode":"643",
      "status":"Active",
      "operationStatus":"transaction",
      "bic":"044525974",
      "category":"fee"
    })
    operation = TinkoffApi::Webhooks::Operation.parse_transactions(json)

    operation.operation_id.should eq "64be58f9-c7fc-0027-96ba-763ec56a2317"
    operation.document_number.should be_nil
    operation.operation_amount.should be_nil
    operation.counter_party.should be_nil
    operation.description.should be_nil
    operation.merch.should be_nil
  end

  it "parses official account-info webhook example" do
    json = JSON_FIXTURES["official_account_info_example"]
    operation = TinkoffApi::Webhooks::Operation.parse_transactions(json)

    operation.operation_id.should eq "126cc5a2-41ca-0083-9017-5863a14692df"
    operation.acquirer_id.should be_nil
    operation.kbk.should eq "18210501011011000110"
    operation.oktmo.should eq "34602403101"
    operation.tax_evidence.should eq "тп"
    operation.nal_type.should eq "0"

    merch = operation.merch.not_nil!
    merch.id.should be_nil
    merch.address.should eq "Лубянская пл., д.1"
    merch.city.should eq "Москва"
    merch.index.should eq "123103"
    merch.name.should eq "ТОЧКА ПАО БАНКА"
  end

  it "raises error for unknown operation type" do
    json = %({"operationId":"test","typeOfOperation":"Unknown","accountNumber":"123"})
    expect_raises(JSON::SerializableError, /Unknown enum/) do
      TinkoffApi::Webhooks::Operation.parse_transactions(json)
    end
  end
end 