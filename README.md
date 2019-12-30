# farsifu
farsifu is a toolbox for developing ruby applications in Persian (Farsi) language.

## Features
* Converting numbers to and from Persian numbers
* Spelling numbers in Persian (supports ordinal spelling of numbers in Persian)
* Converting Persian spelling of numbers back to normal numbers (see examples below)
* List of Iran's provinces, cities and counties
* List of countries in Persian

## Examples:
``` ruby
    "1234567890,;".to_farsi   # => "۱۲۳۴۵۶۷۸۹۰،؛"
    "۱۲۳۴۵۶۷۸۹۰،؛".to_english # => "1234567890,;"
    1024.spell_farsi          # => "یک هزار و بیست و چهار"
    -2567023.spell_farsi      # => "منفی دو میلیون و پانصد و شصت و هفت هزار و بیست و سه"
    7.53.spell_farsi          # => "هفت ممیز پنجاه و سه صدم"
    -0.999.spell_farsi        # => "منفی صفر ممیز نهصد و نود و نه هزارم"
    # Passing false to spell_farsi method will turn off the verbose mode.
    -0.999.spell_farsi(false) # => "منفی نهصد و نود و نه هزارم"
    12.spell_ordinal_farsi    # => "دوازدهم"
    # Note the different when you pass true to spell_ordinal_farsi method. 
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
### 0.6.0 - 01.JAN.2020
* No public API changes
* Enable frozen string literal to speed up Ruby
* Update rspec and refactor tests to version 3.9
* Drop official support for Ruby < 2.4.0 (the Gem might work on older versions, but it's not tested)
* Enable travis-ci to run tests on supported ruby versions
* Enable and configure rubocop

### 0.5.0 - 15.FEB.2013
* [Arash Mousavi](https://github.com/arashm) is now a collaborator.
* Passing false to spell_farsi method will turn off the verbose mode.
* Major internal refactoring. Should not change the external API.

### 0.4.0 - 4.FEB.2013
* Added `farsi_to_number` to convert farsi spelling of numbers to real numbers , courtesy of [Arash Mousavi](https://github.com/arashm)
* Major refactoring and reorganization of the code, courtesy of [Arash Mousavi](https://github.com/arashm)

### 0.3.0 - 28.JAN.2013
* Added Farsi ordinal spelling, courtesy of [Arash Mousavi](https://github.com/arashm)

### 0.2.2 - 11.APR.2011
* Added ruby 1.9 compatibility, courtesy of Brian Kaney 

### 0.2.1 - 11.JAN.2011
* Updated Readme
* Updated rspec to 2.4
* No longer replacing * with ×

### 0.2 - 2.MAR.2010
* Renamed gem from FarsiFu to farsifu
* Added a spec suite
* Migrated the gem to rubygems.org
* Added Iran Module

### 0.02 - 10.AUG.2008
* Converted into a gem
* Added rdocs documentation

### 0.01 - 07.AUG.2008
* Initial release


## Copyright

Copyright (c) 2009-2013 Allen Bargi. See LICENSE for details.
