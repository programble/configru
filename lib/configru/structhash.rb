module Configru
  class StructHash < Hash
    def method_missing(key)
      self[key.to_s]
    end
  end
end
