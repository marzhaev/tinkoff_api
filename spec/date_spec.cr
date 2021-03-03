require "./spec_helper"

describe TinkoffApi::Date do
  it "parses initializes from string" do
    date = TinkoffApi::Date.new("2021-01-02")
    date.value.should eq("2021-01-02")
  end

  it "initializes from Time" do
    t = Time.utc(2021, 1, 2, 0, 0, 0)
    date = TinkoffApi::Date.new(t)
    date.value.should eq("2021-01-02")
  end

  it "raises a wrongly formatted error" do
    expect_raises TinkoffApi::DateException, "Дата должна быть в виде 2021-01-02" do
      TinkoffApi::Date.new("2021.01.02z")
    end
  end

  it "converts Time to TinkoffApi::Date" do
    t = Time.utc(2021, 1, 2, 0, 0, 0)
    date = t.to_tinkoff
    date.value.should eq("2021-01-02")
  end
end
