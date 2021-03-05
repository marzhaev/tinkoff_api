module TinkoffApi
  struct Date
    getter value : String

    # Инициализирует время в нужном формате из текущего
    def initialize
      @value = Time.local.to_s("%Y-%m-%d")
    end

    # Инициализирует время в нужном формате из JSON
    # Бросает ошибку если неправильный формат
    def initialize(puller : JSON::PullParser)
      @value = puller.read_string
      raise DateException.new("Дата должна быть в виде 2021-01-02") unless @value =~ /^20\d{2}-\d{2}-\d{2}$/
    end

    # Инициализирует время в нужном формате из строки
    # Бросает ошибку если неправильный формат
    def initialize(string : String)
      raise DateException.new("Дата должна быть в виде 2021-01-02") unless string =~ /^20\d{2}-\d{2}-\d{2}$/
      @value = string
    end

    # Инициализирует время в нужном формате из стандартного Time
    def initialize(time : Time)
      @value = time.to_s("%Y-%m-%d")
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
