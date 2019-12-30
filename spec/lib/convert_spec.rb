# encoding: utf-8
require 'spec_helper'

describe FarsiFu::Convert do
  it "should convert english num to persian" do
    number = FarsiFu::Convert.new(123)
    number.to_farsi.should == '۱۲۳'
  end

  it "should convert persian num to english" do
    number = FarsiFu::Convert.new('۱۲۳')
    number.to_english.should == '123'
  end
end
