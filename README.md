# IB-Symbols

---
__Documentation: [https://ib-ruby.github.io/ib-doc/](https://ib-ruby.github.io/ib-doc/)__  

__Questions, Contributions, Remarks: [Discussions are opened in ib-api](https://github.com/ib-ruby/ib-api/discussions)__

---
__Predefined symbols and watchlists for contracts__

To activate use

```
gem 'ib-symbols'
```
in the Gemfile and 
```
require 'ib-api'
require 'ib/symbols'
```
in your script

---

## Handy Templates

`IB::Symbols::Index`, `IB::Symbols::Futures` and `IB::Symbols::Options` contain most popular contracts.

To list the predefined contracts use
```ruby
Symbols::Options.all.each{|y| puts [y,Symbols::Options.send(y).to_human].join( "\t")}
aapl	<Option: AAPL 202303 call 130.0 SMART USD>
ge	<Option: GE 202303 call 7.0 SMART USD>
goog100	<Option: GOOG 202303 call 100.0  USD>
ibm	<Option: IBM 202303 put 0.0 SMART >
ibm_lazy_expiry	<Option: IBM  put 140.0 SMART >
ibm_lazy_strike	<Option: IBM 202303 put 0.0 SMART >
    ...
    
Symbols::Futures.all.each{|y| puts [y ,Symbols::Futures.send(y).verify.to_human].join "\t" }
dax	<Future: DAX 20230317 EUR>
es	<Future: ES 20230317 USD>
eur	<Future: EUR 20230313 USD>
gbp	<Future: GBP 20230313 USD>
hsi	<Future: HSI 20230330 HKD>
jpy	<Future: JPY 20230313 USD>
   ...

```
The expiry is set to the next monthly or quaterly option/future expiration date. Most options are defined
without a strike. To specify a »real« contract use the merge method:

```ruby
stoxx_option = IB::Symbols::Option.stoxx.merge( expiry: 202306, strike: 3950, right: :call )
```


## Watchlists


The GUI-Version of the TWS organizes symbols in different pages (Watchlists). 

**`IB-Ruby`** uses the same concept to organize and optimize operational issues and to support research and systematic trading efforts. The lists are organized as `Enumerator`, which extents its use. This feature lives entirely in the filesystem, no database is required, no further dependency is involved.

By default, Watchlists reside in the `symbols`-directory of `ib-symbols`. This can be changed anytime through
```
> IB::Symbols.set_origin '.'  # (a valid path, either relative or absolute)
 => #<Pathname:.> 
> IB::Symbols.set_origin( ".").realpath
 => #<Pathname:/home/ubuntu/workspace/ib-symbols/bin>
```


### Symbol Collections
Everything is kept elementary simple: Collections are stored as editable files. The format is YAML. 

The CRUD Cycle
```ruby
> IB::Symbols.allocate_collection :Demo
 => IB::Symbols::Demo               # file /symbols/Demo is created and Modul is established
> IB::Symbols::Demo.add_contract :uso , IB::Stock.new( symbol: 'USO' )
 => 235                             # returns the count of written bytes to the file 
> IB::Symbols::Demo.uso             # returns the stored contract
 => #<IB::Stock:0x0000000002c814f8 @attributes={:symbol=>"USO", :created_at=>2018-04-29 18:47:01 +0000, :con_id=>0, :right=>"", :exchange=>"SMART", :include_expired=>false, :sec_type=>"STK", :currency=>"USD"}> 
> IB::Symbols::Demo.add_contract :ford , IB::Stock.new( symbol: 'F' )
 => 465 
> IB::Symbols::Demo.all
 => [:ford, :uso]                    # lists all stored contracts
> IB::Symbols::Demo.remove_contract :uso
> IB::Symbols::Demo.all
 => [:ford] 
> IB::Symbols::Demo.purge_collection  # deletes the file and erases the contracts kept in memory
 => nil 
head :012 > IB::Symbols::Demo.all
 => [] 
```


```



