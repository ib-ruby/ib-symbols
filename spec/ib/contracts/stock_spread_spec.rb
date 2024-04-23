require 'combo_helper'
RSpec.shared_examples 'spread_params' do

end

RSpec.describe "IB::StockSpread" do
  before(:all) do
    establish_connection
    ib =  IB::Connection.current
    ib.activate_plugin 'spread-prototypes'
		ib.subscribe( :Alert ){|y|  puts y.to_human }
  end

  after(:all) do
    close_connection
  end


	context "initialize without ratio"  do
		subject { IB::StockSpread.fabricate IB::Stock.new( symbol:'T' ), IB::Stock.new(symbol: 'GE') }
		it{ is_expected.to be_a IB::Spread }
#		it_behaves_like 'a valid Estx Combo'

		its(:symbol){ is_expected.to eq "GE,T" }
		its( :legs ){ is_expected.to have(2).elements}
#		its( :market_price ){ is_expected.to be_a BigDecimal }

	end

	context "initialize with ratio" do
		subject { IB::StockSpread.fabricate IB::Stock.new( symbol:'T' ), IB::Stock.new(symbol: 'GE'), ratio:[1,-3] }
		it{ is_expected.to be_a IB::Spread }
#		it_behaves_like 'a valid Estx Combo'

		its(:symbol){ is_expected.to eq "GE,T" }
		its( :legs ){ is_expected.to have(2).elements}
#		its( :market_price ){ is_expected.to be_a BigDecimal }

	end
	context "initialize with (reverse) ratio" do
		subject { IB::StockSpread.fabricate IB::Stock.new( symbol:'GE' ), IB::Stock.new(symbol: 'T'), ratio:[1, -3] }
		it{ is_expected.to be_a IB::Spread }
#		it_behaves_like 'a valid Estx Combo'
		its(:symbol){ is_expected.to eq "GE,T" }
		its( :legs ){ is_expected.to have(2).elements}
#		its( :market_price ){ is_expected.to be_a BigDecimal }

	end
end
