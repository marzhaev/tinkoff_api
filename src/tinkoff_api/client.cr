module TinkoffApi
  abstract class ClientAbstract
    abstract def path() : String

    getter response : HTTP::Client::Response?

    def initialize
      uri = URI.parse(TINKOFF_SERVER)
      @client = HTTP::Client.new(uri)

      raise ConfigurationException.new("Не задан ключ доступа к токен Тинькоффа для сценария селф-сервиса.") unless ENV["TINKOFF_ACCESS_TOKEN"]?

      @client.before_request do |request|
        request.headers.add("Content-Type", "application/json")
        request.headers.add("Authorization", "Bearer #{ENV["TINKOFF_ACCESS_TOKEN"]}")
      end
    end

    private def make_request(&block : String -> T) forall T
      @response = @client.get(path)
      verify_status
      yield(@response.as(HTTP::Client::Response).body)
    end

    private def verify_status
      if resp = @response
        case resp.status_code
        when 200 then true
        when 400, 401, 403, 422, 500 then raise ServerException.new("Сервер ответил кодом #{resp.status_code}: #{error_message}")
        else
          ServerException.new("Сервер ответил кодом #{resp.status_code}")
        end
      end
    end

    private def error_message : String?
      if resp = @response
        begin
          JSON.parse(resp.body)["errorMessage"]?.try(&.as_s?)
        rescue
          resp.body
        end
      end
    end

    class ServerException < Exception
    end

    class ConfigurationException < Exception
    end
  end
end
