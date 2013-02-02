# encoding: utf-8

module FarsiFu
  class NumToWord

    def initialize(number)
      @number = number
    end

    # Spells a number in Persian
    # accpets english numbers (in float,fixnum or string)
    #
    # Example:
    #   5678.spell_farsi # => "پنج هزار و ششصد و هفتاد و هشت"
    def spell_farsi
      # Distigushing the number (float and )
      if @number.class == Float
        num_array = @number.to_f.to_s.split(".").first.split(//).reverse
        dec_array = @number.to_f.to_s.split(".").last.split(//).slice(0..9).compact.reverse
        dec_copy_b = dec_array.clone ; dec_copy_a = dec_array.clone
        result = spell(num_array)
        ( result += PERSIAN_DIGIT_SIGN[2] + spell(dec_array) + " " + PERSIAN_DIGIT_SPELL["decimals"][dec_copy_a.size].to_s )  unless [PERSIAN_DIGIT_SPELL[0][10],""].include? spell(dec_copy_b)
        return result
      else
        num_array = @number.to_i.to_s.split(//).reverse
        return spell(num_array)
      end
    end

    # Spells numbers in sequentional format. If pass `true`, it will use the second format
    #
    # Example:
    #   1.spell_ordinal_farsi       # => "اول"
    #   121.spell_ordinal_farsi     # => "صد و بیست و یکم"
    #   2.spell_ordinal_farsi(true) # => "دومین"
    #   2054.spell_ordinal_farsi(true) # => "دو هزار و پنجاه چهارمین"
    def spell_ordinal_farsi(*args)
      if args[0]
        exceptions = {0 => "صفر", 1 => "اولین", 3 => "سومین"}
        suffix = "مین"
      else
        exceptions = {0 => "صفر", 1 => "اول", 3 => "سوم"}
        suffix = "م"
      end

      make_ordinal_spell(exceptions, suffix)
    end

  private #---------------------------------------------------------
    def spell(num_array)
      # Dealing with signs
      sign_m = num_array.include?("-") ? PERSIAN_DIGIT_SIGN[0] : ""
      sign_p = num_array.include?("+") ? PERSIAN_DIGIT_SIGN[1] : ""
      num_array.delete_at(num_array.index("-")) if sign_m.size > 0
      num_array.delete_at(num_array.index("+")) if sign_p.size > 0
      sign = sign_m + sign_p

      zillion = 0
      farsi_number = []

      # Dealing with Zero
      if (num_array.length == 1 && num_array[0] == "0" )
        farsi_number = [PERSIAN_DIGIT_SPELL[0][10]]
        num_array = []
      end

      while num_array.length > 0 do
        spelling = []
        num_array[0..2].each_with_index do |digit,index|
            spelling[index] = PERSIAN_DIGIT_SPELL[index][digit.to_i]
            if index == 1 && digit == "1"   # Dealing with 10..19
               spelling[1] = PERSIAN_DIGIT_SPELL["10..19"][num_array[0].to_i]
               spelling[0] = nil
             end
        end

        3.times { num_array.shift if num_array.length > 0 } # Eliminating the first 3 number of the array
        dig = spelling.reverse.compact.join(PERSIAN_DIGIT_JOINT)
        if dig.size > 0
          dig << (" " + PERSIAN_DIGIT_SPELL["zillion"][zillion].to_s)
          farsi_number.unshift(dig)
        end

        zillion += 1
      end # End of While

      sign + farsi_number.compact.join(PERSIAN_DIGIT_JOINT).strip
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