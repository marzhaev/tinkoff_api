# Compiles with Tinkoff's Swagger 'BankStatementOperation' model

module TinkoffApi
  module BankStatement
    class Operation
      include JSON::Serializable

      enum CounteragentType
        Payer
        Recipient
      end

      # Позволяет инициализировать платёжное поручение для последующего ручного заполнения
      def initialize
        @id = ""
        @payer_name = ""
        @payer_bic = ""
        @payer_bank = ""
        @recipient_account = ""
        @recipient_bic = ""
        @recipient_bank = ""
        @operation_type = ""
        @payment_purpose = ""
        @creator_status = ""
        @recipient_name = ""
        @date = TinkoffApi::Date.new
        @draw_date = TinkoffApi::Date.new
        @charge_date = TinkoffApi::Date.new
        @amount = 0.0
      end

      {% for f in ["id", "payerName", "payerInn?", "payerAccount?", "payerCorrAccount?", "payerBic", "payerBank", "recipientInn?", "recipientAccount", "recipientCorrAccount?", "recipientBic", "recipientBank", "operationType", "paymentPurpose", "creatorStatus", "payerKpp?", "recipientKpp?", "executionOrder?", "paymentType?", "uin?", "kbk?", "oktmo?", "taxEvidence?", "taxPeriod?", "taxDocNumber?", "taxDocDate?", "taxType?"] %}
        @[JSON::Field(key: {{ f.id.stringify.gsub(/\?/, "") }} )]
        property {{ f.id.stringify.underscore.gsub(/\?/, "").id }} : String{{ f.id.stringify.ends_with?('?') ? "?".id : "".id }}
      {% end %}

      # For the sake of consistency we rename this field
      @[JSON::Field(key: "recipient" )]
      property recipient_name : String

      {% for f in ["date", "drawDate", "chargeDate"] %}
        @[JSON::Field(key: "{{ f.id }}")]
        property {{ f.id.stringify.underscore.id }} : TinkoffApi::Date
      {% end %}

      @[JSON::Field(key: "amount")]
      property amount : Float64

      def payer : Counteragent
        counteragent(CounteragentType::Payer)
      end

      def recipient : Counteragent
        counteragent(CounteragentType::Recipient)
      end

      def counteragent(type_ : CounteragentType) : Counteragent
        v = case type_
        when CounteragentType::Payer
          Counteragent.new(
            name: payer_name,
            inn: payer_inn,
            account: payer_account,
            corr_account: payer_corr_account,
            bic: payer_bic,
            bank: payer_bank,
            kpp: payer_kpp
          )
        when CounteragentType::Recipient
          Counteragent.new(
            name: recipient_name,
            inn: recipient_inn,
            account: recipient_account,
            corr_account: recipient_corr_account,
            bic: recipient_bic,
            bank: recipient_bank,
            kpp: recipient_kpp
          )
        end

        v.as(Counteragent)
      end
    end
  end
end
