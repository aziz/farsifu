# farsifu
farsifu is a toolbox for developing ruby applications in Persian (Farsi) language.

## Features
* Converting numbers to Persian numbers
* Spelling numbers in Persian (also support ordinal spelling)
* List of Iran's provinces, cities, counties
* List of countries in Persian

## Examples:
``` ruby
    "1234567890,;".to_farsi   # => "۱۲۳۴۵۶۷۸۹۰،؛"
    "۱۲۳۴۵۶۷۸۹۰،؛".to_english # => "1234567890,;"
    1024.spell_farsi          # => "یک هزار و بیست و چهار"
    -2567023.spell_farsi      # => "منفی دو میلیون و پانصد و شصت و هفت هزار و بیست و سه"
    7.53.spell_farsi          # => "هفت ممیز پنجاه و سه صدم"
    -0.999.spell_farsi        # => "منفی صفر ممیز نهصد و نود و نه هزارم"
    12.spell_ordinal_farsi    # => "دوازدهم"
    12.spell_ordinal_farsi(true)    # => "دوازدهمین"
    "هزار و چهل و پنج".farsi_to_number  # => 1045


    Iran::Provinces
    # => returns an array of hashes like below
    # [{:name => "آذربایجان شرقی", :eng_name => "Azerbaijan, East",
    #   :capital => "تبریز", :eng_capital => "Tabriz", 
    #   :counties => ["آذرشهر", "اسکو",..."]...]

    Iran::Countries
    # => returns an array of hashes like below
    # [ { :iso2 => 'AI', :fa => 'آنگیل', :en => 'Anguilla' }, ...]
```

## Install
    gem install farsifu

## Changelog
### 0.4.0 - 4.FEB.2013
* added `farsi_to_number` to convert farsi spelling of numbers to real numbers , courtesy of [Arash Mousavi](https://github.com/arashm)
* Major refactoring and reorganization of the code, courtesy of [Arash Mousavi](https://github.com/arashm)


### 0.3.0 - 28.JAN.2013
* added farsi ordinal spelling, courtesy of [Arash Mousavi](https://github.com/arashm)


### 0.2.2 - 11.APR.2011
* added ruby 1.9 compatibility, courtesy of Brian Kaney 

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

Copyright (c) 2009-2013 Allen Bargi. See LICENSE for details.
