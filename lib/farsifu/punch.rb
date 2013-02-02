module Convert
  def to_farsi
    FarsiFu::Convert.new(self).to_farsi
  end
  alias_method :to_persian, :to_farsi

  def to_english
    FarsiFu::Convert.new(self).to_english
  end
end

module NumToWord
  def spell_farsi
    FarsiFu::NumToWord.new(self).spell_farsi
  end

  def spell_ordinal_farsi(*args)
    FarsiFu::NumToWord.new(self).spell_ordinal_farsi(args[0])
  end
end

module WordToNum
  def to_number
    FarsiFu::WordToNum.new(self).to_number
  end
end

class String
  include Convert
  include WordToNum
end

class Numeric
  include NumToWord
end

# Seems that Numeric works for both Float and Integers
# class Float
#   include NumToWord
# end
