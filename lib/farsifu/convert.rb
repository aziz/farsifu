# frozen_string_literal: true

module FarsiFu
  class Convert
    def initialize(number)
      @number = number
    end

    # :startdoc:

    # Returns a string which is the equivalent English number of a Persian number (in String)
    #
    # Example:
    #   "۱۲۳".to_english  # => "123"
    def to_english
      to_s.tr(PERSIAN_CHARS, ENGLISH_CHARS)
    end

    # Returns a string which is the equivalent Persian number of an English
    # number (in String)
    # accepts instances of String, Integer and Numeric classes
    # (Fixnum, Bignum and floats are accepted)
    #
    # alias: to_persian
    #
    # Example:
    #   "123".to_farsi    # => "۱۲۳"
    #   "456".to_persian  # => "۴۵۶"
    #   789.to_farsi      # => "۷۸۹"
    def to_farsi
      to_s.tr(ENGLISH_CHARS, PERSIAN_CHARS)
    end

    def to_s
      @number.to_s
    end
  end
end
