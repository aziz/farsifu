# farsifu
farsifu is a toolbox for developing ruby applications in Persian (Farsi) language.

## Features
* Coverting numbers to Persian numbers
* Spelling numbers in Persian
* List of Iran's provinces, cities, counties
* List of countries in Persian

## Examples:
    "1234567890,;".to_farsi   # => "۱۲۳۴۵۶۷۸۹۰،؛"
    "۱۲۳۴۵۶۷۸۹۰،؛".to_english # => "1234567890,;"
    1024.spell_farsi          # => "یک هزار و بیست و چهار"
    -2567023.spell_farsi      # => "منفی دو میلیون و پانصد و شصت و هفت هزار و بیست و سه"
    7.53.spell_farsi          # => "هفت ممیز پنجاه و سه صدم"
    -0.999.spell_farsi        # => "منفی صفر ممیز نهصد و نود و نه هزارم"
    
    Iran::Provinces
    # => returns an array of hashes like below
    # [{:name => "آذربایجان شرقی", :eng_name => "Azerbaijan, East",
    #   :capital => "تبریز", :eng_capital => "Tabriz", 
    #   :counties => ["آذرشهر", "اسکو",..."]...]

    Iran::Countries
    # => returns an array of hashes like below
    # [ { :iso2 => 'AI', :fa => 'آنگیل', :en => 'Anguilla' }, ...]

## Install
    gem install farsifu

## History

### 0.2.1 - 11.JAN.2011
* updated readme
* now using rspec 2.4
* no longer replacing * with ×

### 0.2 - 2.MAR.2010
* renamed gem from FarsiFu to farsifu
* Added a spec suite
* Migrated the gem to rubygems.org
* Added Iran Module

### 0.02 - 10.AUG.2008
* converted into a gem
* rdocs added

### 0.01 - 07.AUG.2008
* initial release


## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Allen Bargi. See LICENSE for details.
