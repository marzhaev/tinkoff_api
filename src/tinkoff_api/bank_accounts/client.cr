require "../client"

module TinkoffApi
  module BankAccounts
    class Client < TinkoffApi::ClientAbstract
      PATH = "/api/v2/bank-accounts"

      def path : String
        TINKOFF_PATH_PREFIX + PATH
      end

      def execute : Response
        make_request do |body|
          BankAccounts::Response.from_json(body)
        end
      end
    end
  end
end
