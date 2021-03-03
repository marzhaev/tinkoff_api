module TinkoffApi
  module Company
    class Bank
      include JSON::Serializable

      {% for f in ["bankName", "bankAddress", "corrAccount", "bankInn", "bankBic"] %}
        @[JSON::Field(key: "{{ f.id }}")]
        property {{ f.id.stringify.underscore.id }} : String
      {% end %}
    end
  end
end
