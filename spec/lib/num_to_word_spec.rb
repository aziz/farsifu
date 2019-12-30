# frozen_string_literal: true

describe FarsiFu::NumToWord do
  it 'spells positive numbers to Persian' do
    number = FarsiFu::NumToWord.new(1024)

    expect(number.spell_farsi).to eq('یک هزار و بیست و چهار')
  end

  it 'spells negative numbers to Persian' do
    number = FarsiFu::NumToWord.new(-2_567_023)

    expect(number.spell_farsi).to eq('منفی دو میلیون و پانصد و شصت و هفت هزار و بیست و سه')
  end

  it 'spells positive floats to Persian', :aggregate_failures do
    number = FarsiFu::NumToWord.new(45.5)
    expect(number.spell_farsi).to eq('چهل و پنج ممیز پنج دهم')
    number = FarsiFu::NumToWord.new(7.53)
    expect(number.spell_farsi).to eq('هفت ممیز پنجاه و سه صدم')
    number = FarsiFu::NumToWord.new(0.163)
    expect(number.spell_farsi).to eq('صفر ممیز صد و شصت و سه هزارم')
  end

  it 'spells negative floats to Persian', :aggregate_failures do
    number = FarsiFu::NumToWord.new(-124.1)
    expect(number.spell_farsi).to eq('منفی صد و بیست و چهار ممیز یک دهم')

    number = FarsiFu::NumToWord.new(-0.999)
    expect(number.spell_farsi).to eq('منفی صفر ممیز نهصد و نود و نه هزارم')
  end

  it 'should be able to show first type of sequentional numbers to persian', :aggregate_failures do
    nums = { 0 => 'صفر', 1 => 'اول', 3 => 'سوم', 12 => 'دوازدهم', 33 => 'سی و سوم', 121 => 'صد و بیست و یکم' }
    nums.each do |k, v|
      number = FarsiFu::NumToWord.new(k)

      expect(number.spell_ordinal_farsi).to eq(v)
    end
  end

  it 'should be able to show second type of sequentional numbers to persian', :aggregate_failures do
    nums = { 0 => 'صفر', 1 => 'اولین', 3 => 'سومین', 12 => 'دوازدهمین', 33 => 'سی و سومین', 121 => 'صد و بیست و یکمین' }
    nums.each do |k, v|
      number = FarsiFu::NumToWord.new(k)

      expect(number.spell_ordinal_farsi(true)).to eq(v)
    end
  end
end
