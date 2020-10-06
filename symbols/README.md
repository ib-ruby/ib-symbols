This is the default directory of symbol-collections

They are created through


```
cd bin
./console

# creates the file Test.yml
i =  IB::Symbols.allocate_collection :Test

# add a contract
i.add_contract :testcontract , IB::Stock.new( symbol: 'TAP') 

# list



```
