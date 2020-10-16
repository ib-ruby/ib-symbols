# ib-symbols

Predefined symbols and watchlists for contracts

to activate use

```
gem 'ib-symbols',  git: 'https://github.com/ib-ruby/ib-symbols.git'
```
in the Gemfile and 
```
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
```
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
