$: << File.dirname(__FILE__) unless $:.include?(File.dirname(__FILE__))

require 'configru/confighash'

module Configru
  @@hash = ConfigHash.new({})
  
  def self.[](key)
    @@hash[key]
  end
  
  def self.method_missing(key, *args)
    self[key]
  end
end
