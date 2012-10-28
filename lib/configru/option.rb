module Configru
  module OptionMethods
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

  class Option < Struct.new(:type, :default, :validation, :transformation)
    include OptionMethods
  end

  class RequiredOption < Struct.new(:type, :validation, :transformation)
    include OptionMethods
  end

  class OptionArray < Option
    def type?(values)
      return false unless values.is_a?(Array)
      values.all? {|x| x.is_a?(self.type) }
    end

    def valid?(values)
      return true unless self.validation
      values.all? do |x|
        # Use === instead of passing validation as the block to #all? so that
        # non-block validations (Regexp, Range) work
        self.validation === x
      end
    end

    def transform(values)
      return values unless self.transformation
      values.map(&self.transformation)
    end
  end
end
