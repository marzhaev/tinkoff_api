module TinkoffApi
  module Converters
    class OperationConverter
      def self.to_bank_statement(webhook_operation : Webhooks::Operation) : BankStatement::Operation?
        operation = BankStatement::Operation.new

        # Basic fields
        operation.id = webhook_operation.document_number
        operation.operation_type = webhook_operation.type_of_operation.to_s
        operation.payment_purpose = webhook_operation.description
        operation.amount = webhook_operation.operation_amount.to_f64

        # Dates
        operation.date = webhook_operation.authorization_date
        if draw_date = webhook_operation.draw_date
          operation.draw_date = draw_date
        else
          return
        end
        if charge_date = webhook_operation.charge_date
          operation.charge_date = charge_date
        end

        # Payer information
        if payer = webhook_operation.payer
          operation.payer_name = payer.name
          operation.payer_inn = payer.inn
          operation.payer_account = payer.account
          operation.payer_corr_account = payer.corr_account
          operation.payer_bic = payer.bic
          operation.payer_bank = payer.bank_name
          operation.payer_kpp = payer.kpp
        else
          return
        end

        # Recipient information
        if receiver = webhook_operation.receiver
          operation.recipient_name = receiver.name
          operation.recipient_inn = receiver.inn
          operation.recipient_account = receiver.account
          operation.recipient_corr_account = receiver.corr_account
          operation.recipient_bic = receiver.bic
          operation.recipient_bank = receiver.bank_name
          operation.recipient_kpp = receiver.kpp
        else
          return
        end

        # Additional fields
        operation.creator_status = webhook_operation.status
        operation.payment_type = webhook_operation.pay_vo

        operation
      end
    end
  end
end
