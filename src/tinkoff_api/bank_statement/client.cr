require "../client"

module TinkoffApi
  module BankStatement
    class Client < TinkoffApi::ClientAbstract
      PATH = "/api/v1/bank-statement"

      def path() : String
        query = String.build do |io|
          io << "?accountNumber="
          io << @account_number
          if f = @from
            io << "&from="
            io << f.value
          end
          if t = @till
            io << "&till="
            io << t.value
          end
        end

        TINKOFF_PATH_PREFIX + PATH + query
      end

      def execute(@account_number : String, @from : TinkoffApi::Date? = nil, @till : TinkoffApi::Date? = nil) : Response
        make_request do |body|
          BankStatement::Response.from_json(body)
        end
      end
    end
  end
end
