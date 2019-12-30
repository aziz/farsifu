# frozen_string_literal: true

require 'farsifu'
require 'rspec'
require 'pry'

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
