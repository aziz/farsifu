# encoding: utf-8

module FarsiFu
  class NumToWord

    def initialize(number, verbose = true)
      @number  = number.to_s
      @sign    = check_for_sign
      @float   = true if number.is_a? Float
      @verbose = verbose
    end

    # Spells a number in Persian
    # accpets english numbers (in float,fixnum or string)
    #
    # Example:
    #   5678.spell_farsi # => "پنج هزار و ششصد و هفتاد و هشت"
    #   3.22.spell_farsi # => "سه ممیز بیست و دو صدم"
    def spell_farsi
      if @float
        parse_and_spell_float
      else
        parse_and_spell_real_number
      end
    end

    # Spells numbers in sequentional format. If pass `true`, it will use the second format
    #
    # Example:
    #   1.spell_ordinal_farsi       # => "اول"
    #   121.spell_ordinal_farsi     # => "صد و بیست و یکم"
    #   2.spell_ordinal_farsi(true) # => "دومین"
    #   2054.spell_ordinal_farsi(true) # => "دو هزار و پنجاه چهارمین"
    def spell_ordinal_farsi(second_type = false)
      if second_type
        exceptions = {'0' => "صفر", '1' => "اولین", '3' => "سومین"}
        suffix     = "مین"
      else
        exceptions = {'0' => "صفر", '1' => "اول", '3' => "سوم"}
        suffix     = "م"
      end

      make_ordinal_spell(exceptions, suffix)
    end

  private
    def parse_and_spell_real_number
      answer = []
      group_by_power do |power, num|
        three_digit_spell = spell_three_digits(num, power)
        answer.concat three_digit_spell
      end
      spell = answer.compact.reverse.join(' و ').prepend("#{SIGNS[@sign]}")
      # verbose false?
      spell.gsub!(/^(منفی\s|مثبت\s)*یک\sهزار/) {"#{$1}هزار"} unless @verbose
      spell
    end

    def parse_and_spell_float
      # Seperate floating point
      float_num         = @number.match(/\./)
      pre_num, post_num = float_num.pre_match.prepend("#{@sign}"), float_num.post_match
      # To convert it to دهم, صدم...
      floating_point_power       = 10 ** post_num.size

      pre_num_spell              = NumToWord.new(pre_num).spell_farsi
      pre_num_spell << 'صفر' if pre_num == '0' and @verbose
      post_num_spell             = NumToWord.new(post_num).spell_farsi
      floating_point_power_spell = NumToWord.new(floating_point_power, false).spell_ordinal_farsi.gsub(/یک\s*/, '')

      if pre_num != '0' or @verbose
        "#{pre_num_spell} ممیز #{post_num_spell} #{floating_point_power_spell}"
      else
        "#{pre_num_spell if pre_num_spell.size > 0}#{post_num_spell} #{floating_point_power_spell}"
      end
    end

    # checks if the first char is `+` or `-` and returns the sign
    def check_for_sign
      sign = @number.slice(0).match(/(-|\+)/)
      if sign
        # remove the sign from number
        @number.slice!(0)
        sign[1]
      end
    end

    # '1234567' #=> {0=>["7", "6", "5"], 3=>["4", "3", "2"], 6=>["1"]}
    def group_by_power &block
      power = 0
      @number.split('').reverse.each_slice(3) do |digit|
        yield power, digit
        power += 3
      end
    end

    # ["7", "6", "5"], 3 #=> ['هفت هزار', 'شصت', 'پانصد']
    def spell_three_digits(num, power)
      answer = []
      yekan = nil
      num.each_with_index do |n, i|
        # The 'n' is zero? no need to evaluate
        next if n == '0'
        exception_index = n.to_i * (10 ** i)

        case i
        when 0
          # save Yekan to use for 10..19 exceptions
          yekan = n
        when 1
          # If we're in Sadgan and the digit is 1 so it's a number
          # between 10..19 and it's an exception
          if n == '1'
            exception_index = 10 + yekan.to_i
            answer.clear
          end
        end
        answer << EXCEPTIONS_INVERT[exception_index]
      end
      # append power of ten to first number based on `power` passed to function
      # ["7", "6", "5"], 3 #=> ['هفت هزار', 'شصت', 'پانصد']
      answer[0] = "#{answer[0]} #{(POWER_OF_TEN_INVERT[power])}".strip if answer.size > 0
      answer
    end

    def make_ordinal_spell(exceptions, suffix)
      if exceptions.include? @number
        exceptions[@number]
      else
        (spell_farsi + suffix).gsub(/سه(م|مین)$/) { "سو#{$1}" }
      end
    end
  end
end