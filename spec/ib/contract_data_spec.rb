require 'main_helper'


RSpec.shared_examples 'ContractData Message' do 
	subject{ the_message }
  it { is_expected.to be_an IB::Messages::Incoming::ContractData }
	its( :contract         ){ is_expected.to be_a  IB::Contract }
	its( :contract_detail ){ is_expected.to be_a  IB::ContractDetail }
  its( :message_id       ){ is_expected.to eq 10 }
  its( :version          ){ is_expected.to eq 8 }
	its( :buffer           ){ is_expected.to be_empty }

  it 'has class accessors as well' do
    expect( subject.class.message_id).to eq 10
    expect( subject.class.message_type).to eq :ContractData
  end
end

RSpec.describe IB::Messages::Incoming::ContractData do

  context IB::Stock, :connected => true do
    before(:all) do
		  establish_connection
      ib = IB::Connection.current
			ib.send_message :RequestContractDetails, contract: IB::Symbols::Stocks.wfc
      ib.wait_for :ContractDetailsEnd
    end

    after(:all) { close_connection }
		

#		it "inspects" do  # debugging
#			ib = IB::Connection.current
#			contract =  ib.received[:ContractData].contract.first
#			puts contract.inspect
#			contract_details =  ib.received[:ContractData].contract_detail.first
#
#			puts contract_details.inspect
#		end

		it_behaves_like 'ContractData Message' do
			let( :the_message ){ IB::Connection.current.received[:ContractData].first  }  
		end
	end
end # describe IB::Messages:Incoming

