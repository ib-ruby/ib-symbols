# Option contracts definitions.
# TODO: add next_expiry and other convenience from Futures module.
# Notice:  OSI-Notation is broken
module IB
  module Symbols
    module Options
      extend Symbols

			## usage:  IB::Symbols::Options.stoxx.merge( strike: 3300, expiry: 202304 )
      def self.contracts
        @contracts ||= {
          stoxx:  IB::Option.new(symbol: :ESTX50,
                                 expiry: IB::Symbols::Futures.next_expiry ,
                                 right: :put,
                                 trading_class: 'OESX',
                                 currency: 'EUR',
                                 exchange: 'EUREX',
                                 description: "Monthly settled ESTX50  Options"),
          spx:  IB::Option.new(  symbol: :SPX,
                                 expiry: IB::Symbols::Futures.next_expiry ,
                                 right: :put,
                                 trading_class: 'SPX',
                                 currency: 'USD',
                                 exchange: 'SMART',
                                 description: "Monthly settled SPX options"),
         spxw:  IB::Option.new(  symbol: :SPX,
                                 expiry: IB::Symbols::Futures.next_expiry ,
                                 right: :put,
                                 trading_class: 'SPXW',
                                 currency: 'USD', exchange: 'SMART',
                                 description: "Daily settled SPX options"),
			  :spy => IB::Option.new( :symbol   => :SPY,
                                :expiry   => IB::Symbols::Futures.next_expiry,
                                :right    => :put,
                                :currency => "USD",
				:exchange => 'SMART',
                                :description => "SPY Put next expiration"),
			  :rut => IB::Option.new( :symbol   => :RUT,
                                :expiry   => IB::Symbols::Futures.next_expiry,
                                :right    => :put,
                                :currency => "USD",
				:exchange => 'SMART',
                                 description: "Monthly settled RUT options"),
			  :rutw => IB::Option.new( :symbol   => :RUT,
                                :expiry   => IB::Symbols::Futures.next_expiry,
                                :right    => :put,
                                :currency => "USD",
				:exchange => 'SMART',
                                 description: "Weekly settled RUT options"),
			  :russell => IB::Option.new( :symbol   => :RUT,                             # :russell  == :rut !
                                :expiry   => IB::Symbols::Futures.next_expiry,
                                :right    => :put,
                                :currency => "USD",
				:exchange => 'SMART',
                                 description: "Monthly settled RUT options"),
			  :mini_russell => IB::Option.new( :symbol   => :MRUT,
                                :expiry   => IB::Symbols::Futures.next_expiry,
                                :right    => :put,
                                :currency => "USD",
				:exchange => 'SMART',
                                :description => "Weekly settled Mini-Russell2000 options"),
		          :nikkei => IB::Option.new(  symbol: 'N225',
				   expiry: IB::Symbols::Futures.next_expiry,
				   right: :put,
				   currency: 'JPY',
				   multiplier: 1000,
				   exchange: "OSE.JPN",
				   description: "Monthly settled Nikkei-Options" ),
				   
       :aapl => IB::Option.new( :symbol => "AAPL", exchange: 'SMART',
                                :expiry => IB::Symbols::Futures.next_expiry,
                                :right => "C",
                                :strike => 150,
                                :currency => 'USD',
                                :description => "Apple Call 130"),

			:ibm => IB::Option.new( symbol: 'IBM', exchange: 'SMART', right: :put, expiry: IB::Symbols::Futures.next_expiry ,
						description: 'IBM-Option Chain ( quarterly expiry)'),
			:ibm_lazy_expiry => IB::Option.new( symbol: 'IBM', right: :put, strike: 140, exchange: 'SMART',
						       description: 'IBM-Option Chain with strike 140'),
			:ibm_lazy_strike => IB::Option.new( symbol: 'IBM', exchange: 'SMART', right: :put, expiry: IB::Symbols::Futures.next_expiry ,
						       description: 'IBM-Option Chain ( quarterly expiry)'),

	    :goog100 => IB::Option.new( symbol: 'GOOG',
					currency: 'USD',
				        strike: 100,
				        multiplier: 100,
				        right: :call,
				        expiry:  IB::Symbols::Futures.next_expiry,
				        description: 'Google Call Option with quarterly expiry')
        }
      end
    end
  end
end
