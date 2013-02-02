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

class String
  include Convert
end

class Integer
  include NumToWord
end

class Float
  include NumToWord
end