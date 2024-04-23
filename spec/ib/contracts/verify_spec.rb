require 'main_helper'
require 'contract_helper'

RSpec.describe 'IB::Contract.verify' , #:if => :us_trading_hours,
         :connected => true, :integration => true  do

  before(:all) do
    establish_connection
    ib =  IB::Connection.current
    ib.activate_plugin 'verify'
		ib.subscribe( :Alert ){|y|  puts y.to_human }
  end

  after(:all) do
    close_connection
  end


  context "Verify a Stock " do
	subject {IB::Symbols::Stocks.wfc.verify.first}
		it{ is_expected.to be_a IB::Stock }
		it_behaves_like 'a valid Contract Object'
		its( :con_id  )        { is_expected.not_to be_zero }
		its( :contract_detail ){ is_expected.to be_a  IB::ContractDetail }
		its( :primary_exchange){ is_expected.to be_a String }
	end

	context "Verify a Contract by is Con_ID and Smart routing" do
		subject{ IB::Contract.new( con_id: 14217).verify.first }  #  Siemens
		it{ is_expected.to be_a IB::Stock }
		it_behaves_like 'a valid Contract Object'
		its( :con_id  )        { is_expected.not_to be_zero }
		its( :contract_detail ){ is_expected.to be_a  IB::ContractDetail }
		its( :primary_exchange){ is_expected.to be_a String }
		its( :symbol){ is_expected.to eq 'SIE' }
	end

	context "Verify a Contract without SMART routing " do
		# without exchange
		subject{ IB::Contract.new con_id: 95346693 }
    it{ expect( subject.verify ).to eq [] }

		# with exchange
		it_behaves_like 'a complete Contract Object' do
		let( :the_contract ){  IB::Contract.new( con_id: 95346693, exchange: 'SGX').verify.first }

		end
	end
end
