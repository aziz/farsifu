# frozen_string_literal: true

require 'farsifu/punch'

describe 'Farsifu' do
  before(:all) do
    PERSIAN_CHARS = '۱۲۳۴۵۶۷۸۹۰،؛'
    ENGLISH_CHARS = '1234567890,;'
  end

  it 'should convert English numbers to Persian numbers', :aggregate_failures do
    expect(ENGLISH_CHARS.to_farsi).to eq(PERSIAN_CHARS)
    expect(123.to_farsi).to eq('۱۲۳')
  end

  it 'should convert Persian numbers to English numbers', :aggregate_failures do
    expect(PERSIAN_CHARS.to_english).to eq(ENGLISH_CHARS)
  end

  it 'should be able to spell positive and negetive integers in Persian', :aggregate_failures do
    expect(1024.spell_farsi).to eq('یک هزار و بیست و چهار')
    expect(-2_567_023.spell_farsi).to eq('منفی دو میلیون و پانصد و شصت و هفت هزار و بیست و سه')
    expect('+2567023'.spell_farsi).to eq('مثبت دو میلیون و پانصد و شصت و هفت هزار و بیست و سه')
  end

  it 'should be able to spell positive and negetive floats in Persian', :aggregate_failures do
    expect(45.5.spell_farsi).to eq('چهل و پنج ممیز پنج دهم')
    expect(7.53.spell_farsi).to eq('هفت ممیز پنجاه و سه صدم')
    expect(0.163.spell_farsi).to eq('صفر ممیز صد و شصت و سه هزارم')
    expect(-124.1.spell_farsi).to eq('منفی صد و بیست و چهار ممیز یک دهم')
    expect(-0.999.spell_farsi).to eq('منفی صفر ممیز نهصد و نود و نه هزارم')
  end

  it 'should spell in non-verbose mode' do
    expect(1204.spell_farsi(false)).to eq('هزار و دویست و چهار')
    expect(-0.2.spell_farsi(false)).to eq('منفی دو دهم')
    # shouldn't affect floats without zero at the beginning
    expect(1.2.spell_farsi(false)).to eq('یک ممیز دو دهم')
  end

  it 'should be able to show first type of sequentional numbers to persian' do
    nums = { 0 => 'صفر', 1 => 'اول', 3 => 'سوم', 12 => 'دوازدهم', 33 => 'سی و سوم', 121 => 'صد و بیست و یکم' }
    nums.each do |k, v|
      expect(k.spell_ordinal_farsi).to eq(v)
    end
  end

  it 'should be able to show second type of sequentional numbers to persian' do
    nums = { 0 => 'صفر', 1 => 'اولین', 3 => 'سومین', 12 => 'دوازدهمین', 33 => 'سی و سومین', 121 => 'صد و بیست و یکمین' }
    nums.each do |k, v|
      expect(k.spell_ordinal_farsi(true)).to eq(v)
    end
  end
end
