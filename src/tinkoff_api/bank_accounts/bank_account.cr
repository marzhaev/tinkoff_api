# Compiles with Tinkoff's Swagger 'SmeAccountInfo1' model
#
# accountType is an enum of
# - Current
# - Tax
# - Tender
# - Overnight

module TinkoffApi
  module BankAccounts
    class BankAccount
      include JSON::Serializable

      {% for f in ["accountNumber", "name", "currency", "bankBik", "accountType"] %}
        @[JSON::Field(key: "{{ f.id }}")]
        property {{ f.id.stringify.underscore.id }} : String{{ f.id.stringify.ends_with?('?') ? "?".id : "".id }}
      {% end %}

      @[JSON::Field(key: "balance")]
      property balance : Balance

      @[JSON::Field(key: "transitAccount")]
      property transit_account : TransitAccount?
    end
  end
end
