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

        it "returns nil if an important field is missing" do
          webhook_op = Webhooks::Operation.parse_transactions(JSON_FIXTURES["debit_transaction_without_ruble_amount"])
          bank_op = OperationConverter.to_bank_statement(webhook_op)

          bank_op.should be_nil
        end
        
      end
    end
  end
end 