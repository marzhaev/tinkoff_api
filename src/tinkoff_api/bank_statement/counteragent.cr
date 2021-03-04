module TinkoffApi
  module BankStatement
    class Counteragent
      getter name : String
      getter inn : String?
      getter account : String?
      getter corr_account : String?
      getter bic : String
      getter bank : String
      getter kpp : String?
      def initialize(@name : String, @inn : String?, @account : String?, @corr_account : String?, @bic : String, @bank : String, @kpp : String?)
      end
    end
  end
end
