require 'integration_helper'

# Define butterfly
def butterfly symbol, expiry, right, *strikes
	ib = IB::Connection.current
  raise 'Unable to create butterfly, no connection' unless ib && ib.connected?

  legs = strikes.zip([1, -2, 1]).map do |strike, weight|
    # Create contract
    contract = IB::Option.new :symbol => symbol,
                              :expiry => expiry,
                              :right => right,
                              :strike => strike

    # Find out contract's con_id
    ib.clear_received :ContractData, :ContractDataEnd
    ib.send_message :RequestContractData, :id => strike, :contract => contract
    ib.wait_for :ContractDataEnd, 3
    con_id = ib.received[:ContractData].last.contract.con_id

    # Create Comboleg from con_id and weight
    IB::ComboLeg.new :con_id => con_id, :weight => weight
  end

  # Return butterfly Combo
  IB::Bag.new :symbol => symbol,
              :currency => "USD", # Only US options in combo Contracts
              :exchange => "SMART",
              :combo_legs => legs
end

def common_option stock, strike
  # returns a real put-Option of the given stock
   IB::Option.new( symbol: stock.symbol, currency: stock.currency, exchange: 'SMART', strike: strike, right: :put, expiry: IB::Symbols::Futures.next_expiry).verify.first
end

RSpec.shared_examples 'a valid Estx Combo' do

		its( :exchange ) { should eq 'EUREX' }
		its( :symbol )   { should eq "ESTX50" }
#		its( :market_price )   { should be_a Numeric }
end
RSpec.shared_examples 'a valid ES-FUT Combo' do

		its( :exchange ) { should eq 'CME' }
		its( :symbol )   { should eq "ES" }
#		its( :market_price )   { should be_a Numeric }
end

RSpec.shared_examples 'a valid NQ-FUT Combo' do

		its( :exchange ) { should eq 'CME' }
		its( :symbol )   { should eq "NQ" }
#		its( :market_price )   { should be_a Numeric }
end
RSpec.shared_examples 'a valid ZN-FUT Combo' do

		its( :exchange ) { should eq 'CBOT' }
		its( :symbol )   { should eq "ZN" }
#		its( :market_price )   { should be_a Numeric }
end

RSpec.shared_examples 'a valid wfc-stock Combo' do

		its( :exchange ) { should eq 'SMART' }
		its( :symbol )   { should eq "WFC" }
#		its( :market_price )   { should be_a Numeric }
end

RSpec.shared_examples 'a valid Spread' do
		its( :sec_type ) { should eq :bag }
		its( :legs ){ should be_a Array }

	 
end

