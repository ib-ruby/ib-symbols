require 'combo_helper'

RSpec.describe "IB::Vertical" do
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
    subject { IB::Vertical.fabricate IB::Symbols::Options.stoxx.merge(strike: 5000).verify.first , sell: 5200}
		it{ is_expected.to be_a IB::Bag }
		it_behaves_like 'a valid Estx Combo'
	end

	context "build with underlying"  do
		subject{ IB::Vertical.build from: IB::Symbols::Index.stoxx, buy: 5000, sell: 5200, expiry: IB::Future.next_expiry  }

		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid Estx Combo'
	end
	context "build with option" do
    subject{ IB::Vertical.build from: IB::Symbols::Options.stoxx.merge(strike: 5000).verify.first, buy: 5200 }

		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid Estx Combo'
	end
	context "build with Future" do
    subject{ IB::Vertical.build from: IB::Symbols::Futures.es.verify.first, buy: 4800, sell: 5100 }

		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid ES-FUT Combo'

	end
	context "fabricated with FutureOption" do
		subject do
      fo = IB::Vertical.build( from: IB::Symbols::Futures.es.verify.first, buy: 4800, sell: 5100).legs.first
			IB::Vertical.fabricate fo, sell: 5100
    end
		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid ES-FUT Combo'

	end
end
