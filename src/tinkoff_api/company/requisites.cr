module TinkoffApi
  module Company
    class Requisites
      include JSON::Serializable

      {% for f in ["fullName", "address", "inn", "kpp", "ogrn"] %}
        @[JSON::Field(key: "{{ f.id }}")]
        property {{ f.id.stringify.underscore.id }} : String
      {% end %}
    end
  end
end
