module TinkoffApi
  struct Date
    getter value : String

    # Инициализирует время в нужном формате из текущего
    def initialize
      @value = Time.local.to_s("%Y-%m-%d")
    end

    # Инициализирует время в нужном формате из стандартного Time
    def initialize(time : Time)
      @value = time.to_s("%Y-%m-%d")
    end

    # Инициализирует время в нужном формате из JSON
    # Бросает ошибку если неправильный формат
    def initialize(puller : JSON::PullParser)
      string = puller.read_string
      case string
      when /^20\d{2}-\d{2}-\d{2}$/ then @value = string
      when /^\d{2}\.\d{2}\.20\d{2}$/ then
        m = string.match(/^(\d{2})\.(\d{2})\.(20\d{2})$/).as(Regex::MatchData)
        @value = "#{m[3]}-#{m[2]}-#{m[1]}"
      when /^20\d{2}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/ then
        m = string.match(/^(20\d{2})-(\d{2})-(\d{2})T\d{2}:\d{2}:\d{2}Z$/).as(Regex::MatchData)
        @value = "#{m[1]}-#{m[2]}-#{m[3]}"
      else
        raise DateException.new("Дата должна быть в виде 2021-01-02")
      end
    end

    # Инициализирует время в нужном формате из строки
    # Формат 1 - 2021-01-02
    # Формат 2 - 02.01.2021
    # Бросает ошибку если неправильный формат
    def initialize(string : String)
      case string
      when /^20\d{2}-\d{2}-\d{2}$/ then @value = string
      when /^\d{2}\.\d{2}\.20\d{2}$/ then
        m = string.match(/^(\d{2})\.(\d{2})\.(20\d{2})$/).as(Regex::MatchData)
        @value = "#{m[3]}-#{m[2]}-#{m[1]}"
      when /^20\d{2}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/ then
        raise "YAHOO"
        m = string.match(/^(20\d{2})-(\d{2})-(\d{2})T\d{2}:\d{2}:\d{2}Z$/).as(Regex::MatchData)
        @value = "#{m[1]}-#{m[2]}-#{m[3]}"
      else
        raise DateException.new("Дата должна быть в виде 2021-01-02")
      end
    end

    # Переводит дату из выписки в стандартный Time
    def to_time : Time
      Time.parse(@value, DATE_FORMAT, Time::Location::UTC)
    end
  end

  class DateException < Exception
  end
end

struct Time
  def to_tinkoff : TinkoffApi::Date
    TinkoffApi::Date.new(self)
  end
end
