# frozen_string_literal: true

describe Iran do
  it 'module should just work' do
    expect(Iran::Provinces).to be_an(Array)
    expect(Iran::Countries).to be_an(Array)
  end
end
