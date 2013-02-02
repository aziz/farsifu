# encoding: UTF-8

require 'farsifu/constants'
require 'farsifu/convert'
require 'farsifu/num_to_word'
require 'iran/iran'

#:title: Farsifu
module FarsiFu
  # :stopdoc:
  if RUBY_VERSION < '1.9'
    require 'jcode'
    $KCODE = 'u'
  end
end
