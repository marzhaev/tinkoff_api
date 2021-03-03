module TinkoffApi
  module Company
    class Response
      include JSON::Serializable

      {% for f in ["name", "city", "opf"] %}
        @[JSON::Field(key: "{{ f.id }}")]
        property {{ f.id.stringify.underscore.id }} : String
      {% end %}

      {% for f in ["registrationDate"] %}
        @[JSON::Field(key: "{{ f.id }}")]
        property {{ f.id.stringify.underscore.id }} : TinkoffApi::Date
      {% end %}

      @[JSON::Field(key: "requisites")]
      property requisites : Requisites

      @[JSON::Field(key: "bank")]
      property bank : Bank
    end
  end
end
