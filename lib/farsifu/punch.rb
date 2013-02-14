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
  def spell_farsi(verbose = true)
    FarsiFu::NumToWord.new(self, verbose).spell_farsi
  end

  def spell_ordinal_farsi(second_type = false, verbose = true)
    FarsiFu::NumToWord.new(self, verbose).spell_ordinal_farsi(second_type)
  end
end

module WordToNum
  def farsi_to_number
    FarsiFu::WordToNum.new(self).to_number
  end
end

class String
  include Convert
  include NumToWord
  include WordToNum
end

class Numeric
  include Convert
  include NumToWord
end
