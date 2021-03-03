module TinkoffApi
  module BankAccounts
    class Response
      property bank_accounts : Array(BankAccount) = [] of BankAccount

      def initialize(puller : JSON::PullParser)
        puller.read_array do
          @bank_accounts.push( BankAccount.from_json(puller.read_raw) )
        end
      end
    end
  end
end
