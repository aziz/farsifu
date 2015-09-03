# encoding: utf-8

module FarsiFu
  class WordToNum

    def initialize(number_in_words)
      @number_in_words = number_in_words
    end

    # It converts number represented in words to numeral.
    # Example:
    #   "صد و بیست و یک".to_number #=> 121
    def to_number
      return @number_in_words unless @number_in_words.is_a?(String)

      numbers_array = make_integer_array(@number_in_words)

      memory = 0
      answer = 0
      reset = true
      numbers_array.each do |number|
        if reset || !(divisible_by_thousand? number)
          reset = false
          memory += number
        else
          memory *= number
          answer += memory
          memory = 0
          reset = true
        end
      end
      answer += memory
    end

    private

    # returns an array of corresponding numbers from string
    # [1, 1000000, 200, 30, 5, 1000, 400, 30, 3]
    def make_integer_array(number_in_words)
      number_in_words = eliminate_and(number_in_words.strip.squeeze(" ")).split(" ")
      numbers_array = []
      number_in_words.each do |number|
        if power_of_ten? number
          numbers_array << 10**POWER_OF_TEN[number]
        else
          numbers_array << EXCEPTIONS[number]
        end
      end
      numbers_array
    end

    # Removes "و" from the string
    def eliminate_and(number_in_words)
      number_in_words.gsub(/ و /, " ")
    end

    # Checkes if the number is power of divisible by thousand(bigger than 1000)
    def divisible_by_thousand?(number)
      number % 1000 == 0
    end

    # Checks if the number is power of ten
    def power_of_ten?(number)
      POWER_OF_TEN.keys.include? number
    end
  end
end
