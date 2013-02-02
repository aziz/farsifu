# encoding: utf-8

require 'spec_helper'

describe FarsiFu::NumToWord do
  it "should be able to spell positive and negetive integers in Persian" do
    number = FarsiFu::NumToWord.new(1024)
    number.spell_farsi.should == "یک هزار و بیست و چهار"
    number = FarsiFu::NumToWord.new(-2567023)
    number.spell_farsi.should == "منفی دو میلیون و پانصد و شصت و هفت هزار و بیست و سه"
  end

  it "should be able to spell positive and negetive floats in Persian" do
    number = FarsiFu::NumToWord.new(45.5)
    number.spell_farsi.should == "چهل و پنج ممیز پنج دهم"
    number = FarsiFu::NumToWord.new(7.53)
    number.spell_farsi.should == "هفت ممیز پنجاه و سه صدم"
    number = FarsiFu::NumToWord.new(0.163)
    number.spell_farsi.should == "صفر ممیز صد و شصت و سه هزارم"
    number = FarsiFu::NumToWord.new(-124.1)
    number.spell_farsi.should == "منفی صد و بیست و چهار ممیز یک دهم"
    number = FarsiFu::NumToWord.new(-0.999)
    number.spell_farsi.should == "منفی صفر ممیز نهصد و نود و نه هزارم"
  end

  it "should be able to show first type of sequentional numbers to persian" do
    nums = {0 => "صفر",1 => "اول", 3 => "سوم", 12 => "دوازدهم", 33 => "سی و سوم", 121=> "صد و بیست و یکم"}
    nums.each do |k, v|
      number = FarsiFu::NumToWord.new(k)
      number.spell_ordinal_farsi.should == v
    end
  end

  it "should be able to show second type of sequentional numbers to persian" do
    nums = {0 => "صفر",1 => "اولین", 3 => "سومین", 12 => "دوازدهمین", 33 => "سی و سومین", 121=> "صد و بیست و یکمین"}
    nums.each do |k, v|
      number = FarsiFu::NumToWord.new(k)
      number.spell_ordinal_farsi(true).should == v
    end
  end

end