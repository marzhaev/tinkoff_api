require "./spec_helper"

sample = %({
  "accountNumber":"40702810000000000001",
  "saldoIn":1234.56,
  "income":2345.67,
  "outcome":3456.78,
  "saldoOut":4567.89,
  "operation":[
    {
      "id":"117",
      "date":"2021-03-02",
      "amount":354896.4,
      "drawDate":"2021-03-02",
      "payerName":"ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \\"БУЛОЧНАЯ\\"",
      "payerInn":"5000000001",
      "payerAccount":"40702810000000000000",
      "payerCorrAccount":"30101810200000000000",
      "payerBic":"044525593",
      "payerBank":"АО \\"АЛЬФА-БАНК\\"",
      "chargeDate":"2021-03-02",
      "recipient":"ООО \\"КОНДИТЕРСКАЯ\\"",
      "recipientInn":"7700000000",
      "recipientAccount":"40702810000000000000",
      "recipientCorrAccount":"30101810000000000001",
      "recipientBic":"044525974",
      "recipientBank":"АО \\"ТИНЬКОФФ БАНК\\"",
      "operationType":"01",
      "paymentPurpose":"Оплата за булки",
      "creatorStatus":"",
      "payerKpp":"772201001",
      "recipientKpp":"504401001",
      "executionOrder":"5"
    }
  ]
})

sample_tax_operation = %({
  "id":"39",
  "date":"2021-03-01",
  "amount":16724,
  "drawDate":"2021-03-01",
  "payerName":"ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \\"КОНДИТЕРСКАЯ\\"",
  "payerInn":"7700000000",
  "payerAccount":"40702810000000000000",
  "payerCorrAccount":"30101810000000000001",
  "payerBic":"044525974",
  "payerBank":"АО \\\"ТИНЬКОФФ БАНК\\\"",
  "chargeDate":"2021-03-01",
  "recipient":"УФК по Московской области (Инспекция ФНС России по г.Солнечногорску Московской области)",
  "recipientInn":"5044010478",
  "recipientAccount":"03100643000000014800",
  "recipientCorrAccount":"40102810845370000004",
  "recipientBic":"004525987",
  "recipientBank":"ГУ БАНКА РОССИИ ПО ЦФО //УФК ПО МОСКОВСКОЙ ОБЛАСТИ",
  "operationType":"01",
  "uin":"0",
  "paymentPurpose":"Налог на доходы физических лиц за февраль 2021 года.",
  "creatorStatus":"02",
  "payerKpp":"504401001",
  "recipientKpp":"504401001",
  "kbk":"18210102010011000110",
  "oktmo":"46771000",
  "taxEvidence":"ТП",
  "taxPeriod":"МС.02.2021",
  "taxDocNumber":"0",
  "taxDocDate":"0",
  "taxType":"0",
  "executionOrder":"5"
})

describe TinkoffApi::BankStatement::Response do
  it "parses response" do
    obj = TinkoffApi::BankStatement::Response.from_json(sample)
    obj.account_number.should eq("40702810000000000001")
    obj.saldo_in.should eq(1234.56)
    obj.income.should eq(2345.67)
    obj.outcome.should eq(3456.78)
    obj.saldo_out.should eq(4567.89)
  end

  it "parses response operations" do
    obj = TinkoffApi::BankStatement::Response.from_json(sample)
    obj.operation.size.should eq( 1 )
  end

  it "parses response operation" do
    obj = TinkoffApi::BankStatement::Response.from_json(sample).operation[0]
    obj.id.should eq( "117" )
    obj.date.to_time.should eq( Time.utc(2021, 3, 2, 0, 0, 0) )
    obj.amount.should eq( 354896.4 )
    obj.draw_date.to_time.should eq( Time.utc(2021, 3, 2, 0, 0, 0) )
    obj.payer_name.should eq( "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \"БУЛОЧНАЯ\"" )
    obj.payer_inn.should eq( "5000000001" )
    obj.payer_account.should eq( "40702810000000000000" )
    obj.payer_corr_account.should eq( "30101810200000000000" )
    obj.payer_bic.should eq( "044525593" )
    obj.payer_bank.should eq( "АО \"АЛЬФА-БАНК\"" )
    obj.charge_date.to_time.should eq( Time.utc(2021, 3, 2, 0, 0, 0) )
    obj.recipient.should eq( "ООО \"КОНДИТЕРСКАЯ\"" )
    obj.recipient_inn.should eq( "7700000000" )
    obj.recipient_account.should eq( "40702810000000000000" )
    obj.recipient_corr_account.should eq( "30101810000000000001" )
    obj.recipient_bic.should eq( "044525974" )
    obj.recipient_bank.should eq( "АО \"ТИНЬКОФФ БАНК\"" )
    obj.operation_type.should eq( "01" )
    obj.payment_purpose.should eq( "Оплата за булки", )
    obj.creator_status.should eq( "", )
    obj.payer_kpp.should eq( "772201001" )
    obj.recipient_kpp.should eq( "504401001" )
    obj.execution_order.should eq( "5" )
  end

  it "parses an operation with tax fields" do
    obj = TinkoffApi::BankStatement::Operation.from_json(sample_tax_operation)
    pp obj
    obj.id.should eq("39")
    obj.amount.should eq(16724)
    obj.tax_evidence.should eq("ТП")
  end
end
