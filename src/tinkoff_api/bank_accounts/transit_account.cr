# Compiles with Tinkoff's Swagger 'TransitAccount' model

module TinkoffApi
  module BankAccounts
    class TransitAccount
      include JSON::Serializable

      @[JSON::Field(key: "accountNumber")]
      property account_number : String

      @[JSON::Field(key: "balance")]
      property pending_payments : Float64
    end
  end
end
