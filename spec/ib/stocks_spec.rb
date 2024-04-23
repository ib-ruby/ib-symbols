require 'main_helper'


RSpec.describe IB::Symbols::Stocks do
  before(:all) do
    establish_connection
  end
  context "general" do

    it{ expect( IB::Connection.current).to be_a IB::Connection }
    it{ expect( IB::Symbols::Stocks.wfc ).to be_a IB::Contract }
  end

  context "Plugin verify" do
    it "activate verify" do
      ib = IB::Connection.current
      ib.activate_plugin 'verify'
      expect( IB::Symbols::Stocks.wfc.verify ).to be_an Array

    end
    it "Verify gets the con_id" do
       expect( IB::Symbols::Stocks.wfc.verify.first.con_id ).to eq 10375
    end
  end

  context "Plugin eod" do

    it "activate eod" do
      ib = IB::Connection.current
      ib.activate_plugin 'eod'
      expect( IB::Symbols::Stocks.sie.eod ).to be_an Array
    end
    it "Eod reads a bar record" do

      bar = IB::Symbols::Stocks.sie.eod.first
      puts "bar: #{bar}"

      expect( bar.time ).to eq Date.yesterday ## that fails if the test is performed on sundays and mondays
      [ :open, :high, :low, :close, :volume, :wap, :trades ].each do |k|
        expect( bar.attributes.keys ).to include k
      end


    end
  end
end

