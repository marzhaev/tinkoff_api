require "./spec_helper"

sample = %(
  {
    "name":"ООО \\"БУЛОЧНАЯ\\"",
    "city":"МОСКВА",
    "requisites": {
      "fullName":"ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \\"БУЛОЧНАЯ\\"",
      "address":"123456, РОССИЯ, МОСКВА, КРЕМЛЬ, Д1",
      "inn":"7700000000",
      "kpp":"770000000",
      "ogrn":"0000000000000"
    },
    "bank": {
      "bankName":"АО \\"ТИНЬКОФФ БАНК\\"",
      "bankAddress":"Москва, 123060, 1-й Волоколамский проезд, д. 10, стр. 1",
      "corrAccount":"30101810145250000974",
      "bankInn":"7710140679",
      "bankBic":"044525974"
    },
    "registrationDate":"2021-01-02",
    "opf":"ООО"
  }
)

describe TinkoffApi::Company::Response do
  it "parses response's fields" do
    obj = TinkoffApi::Company::Response.from_json(sample)
    obj.name.should eq("ООО \"БУЛОЧНАЯ\"")
    obj.city.should eq("МОСКВА")
    obj.opf.should eq("ООО")
  end

  it "parses response's date" do
    obj = TinkoffApi::Company::Response.from_json(sample)
    obj.registration_date.to_time.should eq( Time.utc(2021, 1, 2, 0, 0, 0) )
  end

  it "parses response's requisites" do
    obj = TinkoffApi::Company::Response.from_json(sample).requisites
    obj.full_name.should eq("ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \"БУЛОЧНАЯ\"")
    obj.address.should eq("123456, РОССИЯ, МОСКВА, КРЕМЛЬ, Д1")
    obj.inn.should eq("7700000000")
    obj.kpp.should eq("770000000")
    obj.ogrn.should eq("0000000000000")
  end

  it "parses response's bank" do
    obj = TinkoffApi::Company::Response.from_json(sample).bank
    obj.bank_name.should eq("АО \"ТИНЬКОФФ БАНК\"")
    obj.bank_address.should eq("Москва, 123060, 1-й Волоколамский проезд, д. 10, стр. 1")
    obj.corr_account.should eq("30101810145250000974")
    obj.bank_inn.should eq("7710140679")
    obj.bank_bic.should eq("044525974")
  end
end
