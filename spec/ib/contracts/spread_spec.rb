require 'combo_helper'

RSpec.describe "IB::Spread" do
  let ( :the_option ){ IB::Symbols::Options.stoxx.merge strike: 5000, right: :call }
  let( :the_spread ) { IB::Calendar.fabricate IB::Symbols::Futures.nq, '3m' }

  before(:all) do
    establish_connection
    ib =  IB::Connection.current
    ib.activate_plugin 'spread-prototypes'
		ib.subscribe( :Alert ){|y|  puts y.to_human }
  end

  after(:all) do
    close_connection
  end


	context "initialize by fabrication" do

		subject{ the_spread }
		it{ is_expected.to be_a IB::Bag }
		it_behaves_like 'a valid NQ-FUT Combo'

    it "has proper combo-legs" do
      expect( subject.combo_legs.first.side ).to eq  :buy
      expect( subject.combo_legs.last.side ).to eq :sell
    end
	end

	context "leg management"   do
		subject { the_spread }

		its( :legs ){ is_expected.to have(2).elements }

		it "add a leg" do
		expect{ subject.add_leg( the_option  )  }.to  change{ subject.legs.size }.by(1)
		end

		it "remove a leg" do
		# non existing leg
		expect{ subject.remove_leg( the_option  )  }.not_to  change{ subject.legs.size }

#		subject.add_leg( the_option  )
		expect{ subject.remove_leg( 0 )  }.to  change{ subject.legs.size }.by(-1)
		end
	end

end
