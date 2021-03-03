module TinkoffApi
  struct Date
    getter value : String

    def initialize(puller : JSON::PullParser)
      @value = puller.read_string
    end

    def initialize(string : String)
      raise DateException.new("Дата должна быть в виде 2021-01-02") unless string =~ /^20\d{2}-\d{2}-\d{2}$/
      @value = string
    end

    def initialize(time : Time)
      @value = time.to_s("%Y-%m-%d")
    end

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
