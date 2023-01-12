require 'integration_helper'

## todo  test with a real account (with historical data permissions )

describe 'Request Historic Data', :connected => true, :integration => true  do

  CORRECT_OPTS = {:id => 567,
                  :contract => IB::Symbols::Stocks[:wfc],
                  :end_date_time => Time.now.to_ib,
                  :duration => '5 D',
                  :bar_size => '15 mins',
                  :data_type => :trades,
                  :format_date => 1}
  before(:all){ establish_connection }

  after(:all) do
    #@ib.send_message :CancelHistoricalData, :id => 456
    close_connection
  end

  context 'Wrong Requests' do
    it 'raises if incorrect bar size' do
      expect do
        IB::Connection.current.send_message :RequestHistoricalData, CORRECT_OPTS.merge(:bar_size => '11 min')
      end.to raise_error /bar_size must be one of/
    end

    it 'raises if incorrect data_type' do
      expect do
         IB::Connection.current.send_message :RequestHistoricalData, CORRECT_OPTS.merge(:data_type => :nonsense)
      end.to raise_error /:data_type must be one of/
    end
  end

  context 'Correct Request' do
    before(:all) do
			ib =  IB::Connection.current
      # No historical data for GBP/CASH@IDEALPRO
			ib.send_message :RequestMarketDataType, :market_data_type => :delayed
      ib.send_message :RequestHistoricalData, CORRECT_OPTS
      ib.wait_for :HistoricalData, 6 # sec
    end

    subject { IB::Connection.current.received[:HistoricalData].last }

    it { expect(IB::Connection.current.received[:HistoricalData]).to have_at_least(1).historic_data }

    it { is_expected.to  be_an IB::Messages::Incoming::HistoricalData }
    its(:request_id) { is_expected.to eq 567 }
    its(:count) { is_expected.to  be_an Integer }
    its(:start_date) { is_expected.to be_a DateTime } 
    its(:end_date) { is_expected.to match DateTime }
    its(:to_human) { is_expected.to match /HistoricalData/ }

    it 'has results Array with returned historic data' do
      expect(subject.results).to be_an Array
      expect(subject.results.size).to eq subject.count
      subject.results.each do |bar|
        expect( bar ).to be_an IB::Bar
        expect( bar.time   ).to be_a(Time)
        expect( bar.open   ).to be_a Numeric 
        expect( bar.high   ).to be_a Numeric
        expect( bar.low    ).to be_a Numeric
				expect( bar.close  ).to be_a Numeric
				expect( bar.wap    ).to  be_a Numeric
				expect( bar.trades ).to  be_an Integer
				expect( bar.volume ).to be_an Integer
      end
    end
  end
end # Request Historic Data
