require "spec_helper"

describe Iran do

  it "module should just work" do
    Iran::Provinces.should be_a_kind_of Array
    Iran::Countries.should be_a_kind_of Array
  end

end