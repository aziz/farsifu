# frozen_string_literal: true

describe FarsiFu::WordToNum do
  let(:number) { 'یک میلیون و دویست و سی و پنج هزار و چهارصد و سی و سه' }
  let(:parser) { FarsiFu::WordToNum }

  it 'converts string to number', :aggregate_failures do
    expect(parser.new(number).to_number).to eq(1_235_433)
    expect(parser.new('صد و بیست و یک').to_number).to eq(121)
    expect(parser.new('هزار و چهل و پنج').to_number).to eq(1045)
    expect(parser.new('صد و دو هزار و هفتصد').to_number).to eq(102_700)
    expect(parser.new(121).to_number).to eq(121)
  end

  it 'works after punching into String class' do
     expect('هزار و چهل و پنج'.farsi_to_number).to eq(1045)
  end
end
