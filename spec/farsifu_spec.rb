# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "farsifu/punch"

describe "Farsifu" do

  before(:all) do
    PERSIAN_CHARS = "۱۲۳۴۵۶۷۸۹۰،؛"
    ENGLISH_CHARS = "1234567890,;"
  end

  it "should convert English numbers to Persian numbers" do
    ENGLISH_CHARS.to_farsi.should == PERSIAN_CHARS
    123.to_farsi.should == '۱۲۳'
  end

  it "should convert Persian numbers to Eersian numbers" do
    PERSIAN_CHARS.to_english.should == ENGLISH_CHARS
  end

  it "should be able to spell positive and negetive integers in Persian" do
    1024.spell_farsi.should == "یک هزار و بیست و چهار"
    -2567023.spell_farsi.should == "منفی دو میلیون و پانصد و شصت و هفت هزار و بیست و سه"
    '+2567023'.spell_farsi.should == "مثبت دو میلیون و پانصد و شصت و هفت هزار و بیست و سه"
  end

  it "should be able to spell positive and negetive floats in Persian" do
    45.5.spell_farsi.should == "چهل و پنج ممیز پنج دهم"
    7.53.spell_farsi.should == "هفت ممیز پنجاه و سه صدم"
    0.163.spell_farsi.should == "صفر ممیز صد و شصت و سه هزارم"
    -124.1.spell_farsi.should == "منفی صد و بیست و چهار ممیز یک دهم"
    -0.999.spell_farsi.should == "منفی صفر ممیز نهصد و نود و نه هزارم"
  end

  it "should spell in non-verbose mode" do
    1204.spell_farsi(false).should eq('هزار و دویست و چهار')
    -0.2.spell_farsi(false).should eq('منفی دو دهم')
    # shouldn't affect floats without zero at the beginning
    1.2.spell_farsi(false).should eq('یک ممیز دو دهم')
  end

  it "should be able to show first type of sequentional numbers to persian" do
    nums = {0 => "صفر",1 => "اول", 3 => "سوم", 12 => "دوازدهم", 33 => "سی و سوم", 121=> "صد و بیست و یکم"}
    nums.each do |k, v|
      k.spell_ordinal_farsi.should == v
    end
  end

  it "should be able to show second type of sequentional numbers to persian" do
    nums = {0 => "صفر",1 => "اولین", 3 => "سومین", 12 => "دوازدهمین", 33 => "سی و سومین", 121=> "صد و بیست و یکمین"}
    nums.each do |k, v|
      k.spell_ordinal_farsi(true).should == v
    end
  end

end
