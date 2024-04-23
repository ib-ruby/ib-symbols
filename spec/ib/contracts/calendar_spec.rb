require 'combo_helper'

RSpec.describe "IB::Calendar" do
  let ( :the_option ){ IB::Symbols::Options.stoxx.merge strike: 5000, right: :call }
  before(:all) do
    establish_connection
    ib =  IB::Connection.current
    ib.activate_plugin 'spread-prototypes'
    ib.activate_plugin 'verify'
    ib.activate_plugin 'roll'
		ib.subscribe( :Alert ){|y|  puts y.to_human }
  end

  after(:all) do
    close_connection
  end


	context "initialize with master-option" do
    subject { IB::Calendar.fabricate the_option,  (Date.today + 24).strftime("%Y%m%d") }
		it{ is_expected.to be_a IB::Bag }
		it_behaves_like 'a valid Estx Combo'
	end

	context "initialize with underlying"  do
		subject{ IB::Calendar.build( from: IB::Symbols::Index.stoxx,
																 strike: 5000,
																 right: :put,
																 front:  IB::Option.next_expiry ,
																 back:  '-1m'
															 ) }

		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid Estx Combo'
	end
	context "initialize with Future" do
    subject{ IB::Calendar.fabricate  IB::Symbols::Futures.zn.next_expiry, '3m' }

		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid ZN-FUT Combo'
	end
end
