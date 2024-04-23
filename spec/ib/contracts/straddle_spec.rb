require 'combo_helper'
STRIKE_ESTX =  5000   # fill in an appropiate strike for eurostoxx
STRIKE_WFC =  55      # same for Wells Fargo
RSpec.describe "IB::Straddle" do
  let ( :the_option ){ IB::Symbols::Options.stoxx.merge( strike: STRIKE_ESTX).verify.first }
	let ( :the_bag ){ IB::Symbols::Combo::stoxx_straddle }
  before(:all) do
    establish_connection
    ib =  IB::Connection.current
    ib.activate_plugin 'spread-prototypes'
    ib.activate_plugin 'verify'
		ib.subscribe( :Alert ){|y|  puts y.to_human }
  end

  after(:all) do
    close_connection
  end


	context "fabricate with master-option" do
    subject { IB::Straddle.fabricate IB::Symbols::Options.stoxx.merge( strike: STRIKE_ESTX ).verify.first }
		it{ is_expected.to be_a IB::Bag }
		it_behaves_like 'a valid Estx Combo'
	end

	context "build with index underlying"  do
		subject{ IB::Straddle.build from: IB::Symbols::Index.stoxx,
                              strike: STRIKE_ESTX ,
                              expiry: IB::Symbols::Futures.next_expiry ,
                       trading_class: 'OESX' }

		it{ is_expected.to be_a IB::Spread  }
		it_behaves_like 'a valid Estx Combo'
	end

	context "build with future underlying"  do
		subject{ IB::Straddle.build from: IB::Symbols::Futures.es, strike: 5200 }

		it{ is_expected.to be_a IB::Spread  }
		it_behaves_like 'a valid ES-FUT Combo'
	end

	context "fabricate with stock underlying" do
		subject{ IB::Straddle.fabricate common_option( IB::Symbols::Stocks.wfc, STRIKE_WFC)  }

		it{ is_expected.to be_a IB::Spread  }
		it_behaves_like 'a valid wfc-stock Combo'
	end

	context "build with option" , pending: true  do
    subject{ IB::Straddle.build from: IB::Symbols::Options.stoxx, strike: STRIKE_ESTX }

		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid Estx Combo'
	end
end
