require "../client"

module TinkoffApi
  module Company
    class Client < TinkoffApi::ClientAbstract
      PATH = "/api/v1/company"

      def path : String
        TINKOFF_PATH_PREFIX + PATH
      end

      def execute : Response
        make_request do |body|
          Company::Response.from_json(body)
        end
      end
    end
  end
end
