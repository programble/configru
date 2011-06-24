module Configru
  class ConfigHash < Hash
    def initialize(hash={})
      super
      merge!(hash)
    end
    
    def merge!(hash)
      hash.each do |key, value|
        if self.include?(key) && value.is_a?(Hash)
          self[key].merge!(value)
        elsif value.is_a?(Hash)
          self[key] = ConfigHash.new(value)
        else
          self[key] = value
        end
      end
    end
    
    def [](key)
      key = key.to_s if key.is_a?(Symbol)
      # For some reason, super(key) returns {} instead of nil when the key
      # doesn't exist :\
      super(key) if self.include?(key)
    end
    
    def method_missing(key, *args)
      self[key]
    end
  end
end
