module Configru
  class StructHash < Hash
    def method_missing(key, *args)
      # Raise NoMethodError if the key does not exist
      super(key, *args) unless args.empty? && self.include?(key.to_s)
      self[key.to_s]
    end
  end
end
