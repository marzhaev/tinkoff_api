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
    
    # Test counter party
    operation.counter_party.account.should eq "40702810110001754490"
    operation.counter_party.name.should eq "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ СОЛ ГРУПП"
    operation.counter_party.inn.should eq "5012073362"
    
    # Test merchant
    operation.merch.id.should eq "TCS1"
    
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
    operation.counter_party.account.should eq "70601810600002740204"
    operation.counter_party.name.should eq "АО ТБанк"
    operation.counter_party.inn.should eq "7710140679"
    
    # Test merchant
    operation.merch.id.should eq "SME"
    operation.merch.city.should eq "MOSCOW"
    operation.merch.country.should eq "RUS"
    operation.merch.name.should eq "АО ТБанк"
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
    operation.counter_party.account.should eq "40702810638000481807"
    operation.counter_party.name.should eq "ООО ПКФ КРИСТАЛЛ"
    operation.counter_party.inn.should eq "9722055157"
    operation.counter_party.bank_name.should eq "ПАО Сбербанк"
    
    # Test merchant
    operation.merch.id.should eq "TCS1"
  end

  it "parses debit transaction without ruble amount correctly" do
    json = JSON_FIXTURES["debit_transaction_without_ruble_amount"]
    operation = TinkoffApi::Webhooks::Operation.parse_transactions(json)

    operation.operation_id.should eq "8b2fe732-db35-00da-a6bb-6b80e513bf36"
    operation.type_of_operation.should eq TinkoffApi::Webhooks::Operation::OperationType::Debit
  end

  it "raises error for unknown operation type" do
    json = %({"operationId":"test","typeOfOperation":"Unknown","accountNumber":"123"})
    expect_raises(JSON::SerializableError, /Unknown enum/) do
      TinkoffApi::Webhooks::Operation.parse_transactions(json)
    end
  end
end 