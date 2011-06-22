module Configru
  class ConfigHash < Hash
    def initialize(hash={})
      hash.each {|k, v| self[k] = v}
    end
    
    def [](key)
      key = key.to_s if key.is_a?(Symbol)
      super(key).is_a?(Hash) ? ConfigHash.new(super(key)) : super(key)
    end
    
    def method_missing(key, *args)
      self[key]
    end
  end
end
