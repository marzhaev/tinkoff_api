require "./spec_helper"

sample = %(
  [
    {
      "accountNumber":"40702810000000000001",
      "name":"Рублевый счет",
      "currency":"643",
      "bankBik":"044525974",
      "accountType":"Current",
      "balance": {
        "otb":3115.42,
        "authorized":0,
        "pendingPayments":0,
        "pendingRequisitions":0
      }
    }, {
      "accountNumber":"40702840000000000002",
      "name":"Долларовый счет",
      "currency":"840",
      "bankBik":"044525974",
      "accountType":"Current",
      "balance": {
        "otb":1961.22,
        "authorized":0,
        "pendingPayments":0,
        "pendingRequisitions":0
      },
      "transitAccount":{
        "accountNumber":"40702840000000000002",
        "balance":0
      }
    }
  ]
)

describe TinkoffApi::BankAccounts::Response do
  it "parses response" do
    accounts = TinkoffApi::BankAccounts::Response.from_json(sample).bank_accounts
    accounts.size.should eq(2)
  end

  it "parses response's account" do
    obj = TinkoffApi::BankAccounts::Response.from_json(sample).bank_accounts[0]
    obj.account_number.should eq( "40702810000000000001" )
    obj.name.should eq( "Рублевый счет" )
    obj.currency.should eq( "643" )
    obj.bank_bik.should eq( "044525974" )
    obj.account_type.should eq( "Current" )
  end

  it "parses response's balanace" do
    obj = TinkoffApi::BankAccounts::Response.from_json(sample).bank_accounts[0].balance
    obj.otb.should eq( 3115.42 )
    obj.authorized.should eq( 0 )
    obj.pending_payments.should eq( 0 )
    obj.pending_requisitions.should eq( 0 )
  end
end
