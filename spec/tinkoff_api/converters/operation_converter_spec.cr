require "../../spec_helper"
require "../../json_fixtures"

module TinkoffApi
  module Converters
    describe OperationConverter do
      describe ".to_bank_statement" do
        it "converts credit transaction correctly" do
          webhook_op = Webhooks::Operation.parse_transactions(JSON_FIXTURES["credit_transaction"])
          bank_op = OperationConverter.to_bank_statement(webhook_op)

          bank_op.should_not be_nil
          bank_op.should be_a(BankStatement::Operation)
          bank_op = bank_op.not_nil!

          # Basic fields
          bank_op.id.should eq "267"
          bank_op.operation_type.should eq "Credit"
          bank_op.amount.should eq 19588.49
          bank_op.payment_purpose.should eq "Оплата по счету № 25-фжр-13 от 31.03.2025 за электротехническую продукцию Сумма 19588-49 В т.ч. НДС  (20%) 3264-75"

          # Payer information
          bank_op.payer_name.should eq "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ СОЛ ГРУПП"
          bank_op.payer_inn.should eq "5012073362"
          bank_op.payer_account.should eq "40702810110001754490"
          bank_op.payer_bic.should eq "044525974"
          bank_op.payer_bank.should eq "АО ТБанк"

          # Recipient information
          bank_op.recipient_name.should eq "ООО ТЭКСЭНЕРГО ЭЛЕКТРИК"
          bank_op.recipient_inn.should eq "5044082271"
          bank_op.recipient_account.should eq "40702810910000045892"
          bank_op.recipient_bic.should eq "044525974"
          bank_op.recipient_bank.should eq "АО ТБанк"

          # Additional fields
          bank_op.creator_status.should eq "Active"
          bank_op.payment_type.should eq "payment-order"
        end

        it "converts debit transaction correctly" do
          webhook_op = Webhooks::Operation.parse_transactions(JSON_FIXTURES["debit_transaction"])
          bank_op = OperationConverter.to_bank_statement(webhook_op)

          bank_op.should_not be_nil
          bank_op.should be_a(BankStatement::Operation)
          bank_op = bank_op.not_nil!

          # Basic fields
          bank_op.id.should eq "298462"
          bank_op.operation_type.should eq "Debit"
          bank_op.amount.should eq 29.0
          bank_op.payment_purpose.should eq "Комиссия за внешний банковский перевод"

          # Payer information
          bank_op.payer_name.should eq "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ ТЭКСЭНЕРГО ЭЛЕКТРИК"
          bank_op.payer_inn.should eq "5044082271"
          bank_op.payer_account.should eq "40702810910000045892"
          bank_op.payer_bic.should eq "044525974"
          bank_op.payer_bank.should eq "АО ТБанк"

          # Recipient information
          bank_op.recipient_name.should eq "АО ТБанк"
          bank_op.recipient_inn.should eq "7710140679"
          bank_op.recipient_account.should eq "70601810600002740204"
          bank_op.recipient_bic.should eq "044525974"
          bank_op.recipient_bank.should eq "АО ТБанк"

          # Additional fields
          bank_op.creator_status.should eq "Active"
          bank_op.payment_type.should eq "bank-order"
        end

        it "converts loan return transaction correctly" do
          webhook_op = Webhooks::Operation.parse_transactions(JSON_FIXTURES["loan_return_transaction"])
          bank_op = OperationConverter.to_bank_statement(webhook_op)

          bank_op.should_not be_nil
          bank_op.should be_a(BankStatement::Operation)
          bank_op = bank_op.not_nil!

          # Basic fields
          bank_op.id.should eq "203"
          bank_op.operation_type.should eq "Credit"
          bank_op.amount.should eq 200000.0
          bank_op.payment_purpose.should eq "Частичный возврат займа по договору №2 от 04.09.2024 г.Сумма 200000-00Без налога (НДС)"

          # Payer information
          bank_op.payer_name.should eq "ООО ПКФ КРИСТАЛЛ"
          bank_op.payer_inn.should eq "9722055157"
          bank_op.payer_account.should eq "40702810638000481807"
          bank_op.payer_bic.should eq "044525225"
          bank_op.payer_bank.should eq "ПАО Сбербанк"

          # Recipient information
          bank_op.recipient_name.should eq "ООО ТЭКСЭНЕРГО ЭЛЕКТРИК"
          bank_op.recipient_inn.should eq "5044082271"
          bank_op.recipient_account.should eq "40702810910000045892"
          bank_op.recipient_bic.should eq "044525974"
          bank_op.recipient_bank.should eq "АО ТБанк"

          # Additional fields
          bank_op.creator_status.should eq "Active"
          bank_op.payment_type.should eq "payment-order"
        end

        it "uses authorizationDate for operation date, not drawDate" do
          json = %({
            "operationId":"date-split",
            "typeOfOperation":"Credit",
            "accountNumber":"40702810910000045892",
            "accountAmount":"100",
            "accountCurrencyDigitalCode":"643",
            "status":"Active",
            "operationStatus":"transaction",
            "bic":"044525974",
            "category":"incomePeople",
            "documentNumber":"1",
            "operationAmount":"100",
            "authorizationDate":"2025-03-31T15:07:40Z",
            "drawDate":"2025-04-01T10:00:00Z",
            "payer":{"account":"40702810110001754490","name":"Payer","inn":"1","bic":"044525974","corrAccount":"30101810145250000974","bankName":"Bank"},
            "receiver":{"account":"40702810910000045892","name":"Receiver","inn":"2","bic":"044525974","corrAccount":"30101810145250000974","bankName":"Bank"}
          })
          webhook_op = Webhooks::Operation.parse_transactions(json)
          bank_op = OperationConverter.to_bank_statement(webhook_op).not_nil!

          bank_op.date.value.should eq "2025-03-31"
          bank_op.draw_date.value.should eq "2025-04-01"
        end

        it "converts a partial webhook using fallbacks instead of dropping it" do
          webhook_op = Webhooks::Operation.parse_transactions(JSON_FIXTURES["debit_transaction_without_ruble_amount"])
          bank_op = OperationConverter.to_bank_statement(webhook_op)

          bank_op.should_not be_nil
          bank_op = bank_op.not_nil!

          bank_op.id.should eq "141"
          bank_op.amount.should eq 20160.0
          bank_op.date.value.should eq "2025-04-01"
          bank_op.draw_date.value.should eq "2025-04-01"
          bank_op.payer_account.should eq "40702810910000045892"
          bank_op.payer_bic.should eq "044525974"
          bank_op.recipient_name.should eq %(ООО "МФК Техэнерго")
          bank_op.recipient_account.should eq "40702810901600006867"
          bank_op.recipient_bic.should eq "044525593"
        end

        it "returns nil when the webhook has no dates" do
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
          webhook_op = Webhooks::Operation.parse_transactions(json)
          OperationConverter.to_bank_statement(webhook_op).should be_nil
        end

        it "maps tax fields from official webhook example" do
          webhook_op = Webhooks::Operation.parse_transactions(JSON_FIXTURES["official_account_info_example"])
          bank_op = OperationConverter.to_bank_statement(webhook_op)

          bank_op.should_not be_nil
          bank_op = bank_op.not_nil!
          bank_op.kbk.should eq "18210501011011000110"
          bank_op.oktmo.should eq "34602403101"
          bank_op.tax_evidence.should eq "тп"
          bank_op.tax_period.should eq "ГД.00.2021"
          bank_op.tax_doc_number.should eq "0"
          bank_op.tax_doc_date.should eq "0"
          bank_op.tax_type.should eq "0"
        end
        
      end
    end
  end
end 