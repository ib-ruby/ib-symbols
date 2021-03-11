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

The GUI-Version of the TWS organizes symbols in different pages (Watchlists). 

**`IB-Ruby`** uses the same concept to organize and optimize operational issues and to support research and systematic trading efforts. The lists are organized as `Enumerator`, which extents its use. This feature lives entirely in the filesystem, no database is required, no further dependency is involved.

By default, Watchlists reside in the `symbols`-directory of `ib-symbols`. This can be changed anytime through
```
> IB::Symbols.set_origin '.'  # (a valid path, either relative or absolute)
 => #<Pathname:.> 
> IB::Symbols.set_origin( ".").realpath
 => #<Pathname:/home/ubuntu/workspace/ib-symbols/bin>
```


## Symbol Collections
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

## Predefined Collections

Most popular `Stocks`, `Options`, `Futures`, `Indices` and `Forex-pairs` are hard-coded.
```ruby
> IB::Symbols::Index.all
 => [:a_d, :asx, :dax, :hsi, :minihsi, :spx, :stoxx, :tick, :trin, :vasx, :vdax, :vhsi, :vix, :volume, :vstoxx] 
> puts IB::Symbols::Index.contracts.values &.to_human
  <Index: DAX EUR (DAX Performance Index.) >
  <Index: AP AUD (ASX 200 Index) >
  <Index: HSI HKD (Hang Seng Index) >
  (...)
  <Index: AD-NYSE  (NYSE Advance Decline Index) >

> Symbols::Forex.eurusd.to_human
 => "<Contract: EUR forex IDEALPRO USD>"
# this contract is valid and can be verified, but the opposide is not supported by IB
> Symbols::Forex.usdeur.verify
TWS Error 200: No security definition has been found for the request
Not a valid Contract :: <Contract: USD forex IDEALPRO EUR>
```

## Pattern based Contract retrieval

To specify a specific Option can be a boaring job. 
You might spend hours searching for a simple error, like a forgotten `:currency` oder `:exchange` entry.

Symbol-Collections can be used as template for everyday searches.

> Example: Customize a Index-Option with quaterly expiry.
>
> The hard coded `Symbols::Options.stoxx` template ensures the retrieval of only one option.
> A simple merge with customized attributes  returns a fully qualified ContractRecord.


```ruby
> IB::Symbols.Options.stoxx.to_human
 => "<Option: ESTX50 202012 put 3000.0 DTB EUR>" 
> Symbols::Options.stoxx.merge( strike: 3300, right: :call).to_human
 => "<Option: ESTX50 202012 call 3300.0 DTB EUR>" 

```


