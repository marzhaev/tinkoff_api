require "log"

module TinkoffApi
  module Converters
    class OperationConverter
      Log = ::Log.for("tinkoff_api.converters")

      def self.to_bank_statement(webhook_operation : Webhooks::Operation) : BankStatement::Operation?
        operation = BankStatement::Operation.new
        missing = [] of String

        operation.id = webhook_operation.document_number || ""
        operation.operation_type = webhook_operation.type_of_operation.to_s
        operation.payment_purpose = webhook_operation.pay_purpose || webhook_operation.description || ""
        operation.creator_status = webhook_operation.status
        operation.payment_type = webhook_operation.pay_vo
        operation.kbk = webhook_operation.kbk
        operation.oktmo = webhook_operation.oktmo
        operation.tax_evidence = webhook_operation.tax_evidence
        operation.tax_period = webhook_operation.tax_period
        operation.tax_doc_number = webhook_operation.tax_doc_number
        operation.tax_doc_date = webhook_operation.tax_doc_date
        operation.tax_type = webhook_operation.nal_type

        amount_source = webhook_operation.operation_amount || webhook_operation.account_amount || webhook_operation.ruble_amount
        unless amount_source
          Log.warn { "Skip webhook #{webhook_operation.operation_id}: missing amount" }
          return
        end
        operation.amount = amount_source.to_f64
        missing << "operationAmount" unless webhook_operation.operation_amount

        timestamp = webhook_operation.authorization_date ||
                    webhook_operation.doc_date ||
                    webhook_operation.trxn_post_date ||
                    webhook_operation.draw_date ||
                    webhook_operation.charge_date
        unless timestamp
          Log.warn { "Skip webhook #{webhook_operation.operation_id}: missing dates" }
          return
        end
        operation.date = timestamp.to_tinkoff
        missing << "authorizationDate" unless webhook_operation.authorization_date

        if draw_date = webhook_operation.draw_date
          operation.draw_date = draw_date.to_tinkoff
        else
          operation.draw_date = timestamp.to_tinkoff
          missing << "drawDate"
        end

        if charge_date = webhook_operation.charge_date
          operation.charge_date = charge_date.to_tinkoff
        else
          operation.charge_date = (webhook_operation.draw_date || timestamp).to_tinkoff
          missing << "chargeDate"
        end

        apply_payer(operation, webhook_operation, missing)
        apply_receiver(operation, webhook_operation, missing)

        unless missing.empty?
          Log.warn { "Webhook #{webhook_operation.operation_id}: converted with missing #{missing.join(", ")}" }
        end

        operation
      end

      private def self.apply_payer(operation : BankStatement::Operation, webhook : Webhooks::Operation, missing : Array(String))
        if payer = webhook.payer
          operation.payer_name = payer.name || ""
          operation.payer_inn = payer.inn
          operation.payer_account = payer.account
          operation.payer_corr_account = payer.corr_account
          operation.payer_bic = payer.bic || ""
          operation.payer_bank = payer.bank_name || ""
          operation.payer_kpp = payer.kpp
          return
        end

        missing << "payer"
        if webhook.type_of_operation.credit?
          if counter_party = webhook.counter_party
            assign_payer_from_counter_party(operation, counter_party)
          end
        else
          operation.payer_account = webhook.account_number
          operation.payer_bic = webhook.bic
        end
      end

      private def self.apply_receiver(operation : BankStatement::Operation, webhook : Webhooks::Operation, missing : Array(String))
        if receiver = webhook.receiver
          operation.recipient_name = receiver.name || ""
          operation.recipient_inn = receiver.inn
          operation.recipient_account = receiver.account || ""
          operation.recipient_corr_account = receiver.corr_account
          operation.recipient_bic = receiver.bic || ""
          operation.recipient_bank = receiver.bank_name || ""
          operation.recipient_kpp = receiver.kpp
          return
        end

        missing << "receiver"
        if webhook.type_of_operation.debit?
          if counter_party = webhook.counter_party
            assign_receiver_from_counter_party(operation, counter_party)
          end
        else
          operation.recipient_account = webhook.account_number
          operation.recipient_bic = webhook.bic
        end
      end

      private def self.assign_payer_from_counter_party(operation : BankStatement::Operation, counter_party : Webhooks::Operation::CounterParty)
        operation.payer_name = counter_party.name || ""
        operation.payer_inn = counter_party.inn
        operation.payer_account = counter_party.account
        operation.payer_corr_account = counter_party.corr_account
        operation.payer_bic = counter_party.bank_bic || ""
        operation.payer_bank = counter_party.bank_name || ""
        operation.payer_kpp = counter_party.kpp
      end

      private def self.assign_receiver_from_counter_party(operation : BankStatement::Operation, counter_party : Webhooks::Operation::CounterParty)
        operation.recipient_name = counter_party.name || ""
        operation.recipient_inn = counter_party.inn
        operation.recipient_account = counter_party.account || ""
        operation.recipient_corr_account = counter_party.corr_account
        operation.recipient_bic = counter_party.bank_bic || ""
        operation.recipient_bank = counter_party.bank_name || ""
        operation.recipient_kpp = counter_party.kpp
      end
    end
  end
end
