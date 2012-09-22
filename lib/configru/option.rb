module Configru
  class Option < Struct.new(:type, :default, :validation, :transformation)
    def type?(value)
      value.is_a?(self.type)
    end

    def valid?(value)
      return true unless self.validation
      self.validation === value
    end

    def transform(value)
      return value unless self.transformation
      self.transformation[value]
    end
  end
end
