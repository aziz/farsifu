# encoding: utf-8
require "spec_helper"

describe FarsiFu::WordToNum do
  let(:number) { "یک میلیون و دویست و سی و پنج هزار و چهارصد و سی و سه" }
  let(:parser) { FarsiFu::WordToNum }
  # it "should eliminate and form string" do
  #   parser.eliminate_and(number).should == "یک میلیون دویست سی پنج هزار چهارصد سی سه"
  # end

  # it "recognize power of ten" do
  #   parser.power_of_ten?("هزار").should be_true
  # end

  # it "checks if the number is divisible by thousand" do
  #   parser.divisible_by_thousand?(1000).should be_true
  # end

  # it "should make number array" do
  #   parser.make_integer_array(number).should == [1, 1000000, 200, 30, 5, 1000, 400, 30, 3]
  # end

  it "converts string to number" do
    parser.new(number).to_number.should == 1235433
    parser.new("صد و بیست و یک").to_number.should == 121
    parser.new("هزار و چهل و پنج").to_number.should == 1045
    parser.new("صد و دو هزار و هفتصد").to_number.should == 102700
    parser.new(121).to_number.should == 121
  end

  it "works after punching into String class" do
    "هزار و چهل و پنج".to_number == 1045
  end
end