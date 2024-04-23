require 'combo_helper'
PUT=5000
CALL=5200
PUT_ES= 5100
CALL_ES=5300
RSpec.describe "IB::Strangle" do
	let ( :the_option ){ IB::Symbols::Options.stoxx.merge strike: PUT }
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
    subject { IB::Strangle.fabricate IB::Symbols::Options.stoxx.merge( strike: PUT ).next_expiry, 200 }
		it{ is_expected.to be_a IB::Bag }
		it_behaves_like 'a valid Estx Combo'
	end

	context "build with underlying" do
		subject{ IB::Strangle.build from: IB::Symbols::Index.stoxx, p: PUT, c: CALL }

		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid Estx Combo'
	end
	context "build with option"  do
    subject{ IB::Strangle.build from: IB::Symbols::Options.stoxx.merge( strike: PUT ), c: CALL }

		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid Estx Combo'
	end


	context "build with Future" do
		subject{ IB::Strangle.build from: IB::Symbols::Futures.es, p: PUT_ES, c: CALL_ES }

		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid ES-FUT Combo'

	end

	context "fabricated with FutureOption" do
		subject do
			fo = IB::Strangle.build( from: IB::Symbols::Futures.es, p: PUT_ES, c: CALL_ES).legs.first
			IB::Strangle.fabricate fo, 200
    end
		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid ES-FUT Combo'

	end

end
