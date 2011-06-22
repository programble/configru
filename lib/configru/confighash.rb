module Configru
  class ConfigHash < Hash
    def initialize(hash={})
      hash.each do |k, v|
        v = ConfigHash.new(v) if v.is_a?(Hash)
        self[k] = v
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
end
