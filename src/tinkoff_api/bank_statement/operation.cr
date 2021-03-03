# Compiles with Tinkoff's Swagger 'BankStatementOperation' model

module TinkoffApi
  module BankStatement
    class Operation
      include JSON::Serializable

      {% for f in ["id", "payerName", "payerInn?", "payerAccount?", "payerCorrAccount?", "payerBic", "payerBank", "recipient", "recipientInn?", "recipientAccount", "recipientCorrAccount?", "recipientBic", "recipientBank", "operationType", "paymentPurpose", "creatorStatus", "payerKpp?", "recipientKpp?", "executionOrder?", "paymentType?", "uin?", "kbk?", "oktmo?", "taxEvidence?", "taxPeriod?", "taxDocNumber?", "taxDocDate?", "taxType?"] %}
        @[JSON::Field(key: {{ f.id.stringify.gsub(/\?/, "") }} )]
        property {{ f.id.stringify.underscore.gsub(/\?/, "").id }} : String{{ f.id.stringify.ends_with?('?') ? "?".id : "".id }}
      {% end %}

      {% for f in ["date", "drawDate", "chargeDate"] %}
        @[JSON::Field(key: "{{ f.id }}")]
        property {{ f.id.stringify.underscore.id }} : TinkoffApi::Date
      {% end %}

      @[JSON::Field(key: "amount")]
      property amount : Float64
    end
  end
end
