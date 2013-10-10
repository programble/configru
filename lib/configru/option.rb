module Configru
  module OptionMethods
    def type?(value)
      value.nil? || value.is_a?(self.type)
    end

    def valid?(value)
      return true unless self.validation
      if self.validation.is_a? Array
        self.validation.include? value
      else
        self.validation === value
      end
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
        super(x)
      end
    end

    def transform(values)
      return values unless self.transformation
      values.map(&self.transformation)
    end
  end
end
