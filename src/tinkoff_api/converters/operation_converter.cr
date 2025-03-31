module TinkoffApi
  module Converters
    class OperationConverter
      def self.to_bank_statement(webhook_operation : Webhooks::Operation) : BankStatement::Operation
        operation = BankStatement::Operation.new

        # Basic fields
        operation.id = webhook_operation.operation_id
        operation.operation_type = webhook_operation.type_of_operation.to_s
        operation.payment_purpose = webhook_operation.pay_purpose
        operation.amount = webhook_operation.operation_amount.to_f64

        # Dates
        operation.date = webhook_operation.authorization_date
        operation.draw_date = webhook_operation.draw_date
        if charge_date = webhook_operation.charge_date
          operation.charge_date = charge_date
        end

        # Payer information
        operation.payer_name = webhook_operation.payer.name
        operation.payer_inn = webhook_operation.payer.inn
        operation.payer_account = webhook_operation.payer.account
        operation.payer_corr_account = webhook_operation.payer.corr_account
        operation.payer_bic = webhook_operation.payer.bic
        operation.payer_bank = webhook_operation.payer.bank_name
        operation.payer_kpp = webhook_operation.payer.kpp

        # Recipient information
        operation.recipient_name = webhook_operation.receiver.name
        operation.recipient_inn = webhook_operation.receiver.inn
        operation.recipient_account = webhook_operation.receiver.account
        operation.recipient_corr_account = webhook_operation.receiver.corr_account
        operation.recipient_bic = webhook_operation.receiver.bic
        operation.recipient_bank = webhook_operation.receiver.bank_name
        operation.recipient_kpp = webhook_operation.receiver.kpp

        # Additional fields
        operation.creator_status = webhook_operation.status
        operation.payment_type = webhook_operation.pay_vo

        operation
      end
    end
  end
end 