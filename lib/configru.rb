require 'yaml'

module Configru
  class ConfigHash < Hash
    def initialize(hash)
      hash.each do |key, value|
        self[key] = value
      end
    end
    
    def [](key)
      key = key.to_s if key.is_a?(Symbol)
      super(key).is_a?(Hash) ? ConfigHash.new(super(key)) : super(key)
    end
    
    def method_missing(key, *args)
      self[key]
    end
  end
  
  @@hash = ConfigHash.new({})
  
  def self.[](key)
    @@hash[key]
  end
  
  def self.method_missing(key, *args)
    self[key]
  end
end
