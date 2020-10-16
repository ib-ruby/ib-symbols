Process of separation from ib-ruby
==================================

* Create the gem with bundle  
  `bundle gem ib-symbols` 

* Move essential files from ib-ruby  
  Source is `lib/ib/symbols` and `lib/ib/symbols_base.rb`
	
* modify `lib/ib/symbols.rb`  
  * Transfer code from `symbols_base.rb_`
	* Add require-statements

* include `bin/console`  
  Copy from `bin/console` and modify to enable offline usage as default  
	Copy `console.yml` as well

* add TestSuite  
  Copy `Guardfile` from ib-ruby  
	Copy `spec_helper` to `spec` directory and modify
	Copy `symbols_spec.rb` to `spec` directory and modify
	Run `bundle exec guard` 

* push gem to github



  
