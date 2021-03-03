# Compiles with Tinkoff's Swagger 'Balance' model

module TinkoffApi
  module BankAccounts
    class Balance
      include JSON::Serializable

      {% for f in ["otb", "authorized", "pendingPayments", "pendingRequisitions"] %}
        @[JSON::Field(key: "{{ f.id }}")]
        property {{ f.id.stringify.underscore.id }} : Float64
      {% end %}
    end
  end
end
