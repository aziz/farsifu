# frozen_string_literal: true

describe FarsiFu::Convert do
  it 'should convert english num to persian' do
    number = FarsiFu::Convert.new(123)

    expect(number.to_farsi).to eq('۱۲۳')
  end

  it 'should convert persian num to english' do
    number = FarsiFu::Convert.new('۱۲۳')

    expect(number.to_english).to eq('123')
  end
end
