require "json"

module TinkoffApi
  module Webhooks
    class Operation
      include JSON::Serializable

      @[JSON::Field(key: "operationId")]
      property operation_id : String
      @[JSON::Field(key: "typeOfOperation")]
      property type_of_operation : OperationType
      @[JSON::Field(key: "accountNumber")]
      property account_number : String
      @[JSON::Field(key: "accountAmount")]
      property account_amount : String
      @[JSON::Field(key: "accountCurrencyDigitalCode")]
      property account_currency_digital_code : String
      property status : String
      @[JSON::Field(key: "operationStatus")]
      property operation_status : String
      property bic : String
      property category : String
      @[JSON::Field(key: "documentNumber")]
      property document_number : String
      @[JSON::Field(key: "operationAmount")]
      property operation_amount : String
      @[JSON::Field(key: "operationCurrencyDigitalCode")]
      property operation_currency_digital_code : String
      @[JSON::Field(key: "rubleAmount")]
      property ruble_amount : String
      @[JSON::Field(key: "counterParty")]
      property counter_party : CounterParty
      property description : String
      @[JSON::Field(key: "authorizationDate")]
      property authorization_date : String
      @[JSON::Field(key: "trxnPostDate")]
      property trxn_post_date : String
      @[JSON::Field(key: "payVo")]
      property pay_vo : String
      property priority : String?
      @[JSON::Field(key: "cardNumber")]
      property card_number : String
      property ucid : String
      property mcc : String
      property merch : Merchant
      @[JSON::Field(key: "acquirerId")]
      property acquirer_id : String
      property rrn : String?
      @[JSON::Field(key: "payPurpose")]
      property pay_purpose : String
      @[JSON::Field(key: "chargeDate")]
      property charge_date : String?
      @[JSON::Field(key: "drawDate")]
      property draw_date : String
      property receiver : Party
      property payer : Party
      @[JSON::Field(key: "docDate")]
      property doc_date : String
      @[JSON::Field(key: "VO")]
      property vo : String

      class CounterParty
        include JSON::Serializable

        property account : String
        @[JSON::Field(key: "bankBic")]
        property bank_bic : String
        @[JSON::Field(key: "bankName")]
        property bank_name : String?
        @[JSON::Field(key: "corrAccount")]
        property corr_account : String
        property inn : String
        property kpp : String?
        property name : String
      end

      class Merchant
        include JSON::Serializable

        property id : String
        property city : String?
        property country : String?
        property name : String?
      end

      class Party
        include JSON::Serializable

        property account : String
        property name : String
        property inn : String
        property kpp : String?
        property bic : String
        @[JSON::Field(key: "corrAccount")]
        property corr_account : String
        @[JSON::Field(key: "bankName")]
        property bank_name : String
      end

      enum OperationType
        Debit
        Credit
    
        def self.from_json(value : JSON::PullParser) : self
          case value.string_value
          when "Debit"
            Debit
          when "Credit"
            Credit
          else
            raise "Unknown operation type: #{value.string_value}"
          end
        end
    
        def to_json(json : JSON::Builder)
          json.string(to_s)
        end
      end

      def self.parse_transactions(json_string : String) : Operation
        Operation.from_json(json_string)
      end
    end
  end
end
