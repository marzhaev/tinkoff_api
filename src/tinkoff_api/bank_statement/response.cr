# Compiles with Tinkoff's Swagger 'SmeBankStatement' model

module TinkoffApi
  module BankStatement
    class Response
      include JSON::Serializable

      @[JSON::Field(key: "accountNumber")]
      property account_number : String

      {% for f in ["saldoIn", "income", "outcome", "saldoOut"] %}
        @[JSON::Field(key: "{{ f.id }}")]
        property {{ f.id.stringify.underscore.id }} : Float64
      {% end %}

      @[JSON::Field(key: "operation")]
      property operation : Array(Operation) = [] of Operation
    end
  end
end
