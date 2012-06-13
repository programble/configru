module Configru
  class Option
    attr_accessor :type, :default, :validate, :transform

    def initialize(type, default, validate, transform)
      @type = type
      @default = default
      @validate = validate
      @transform = transform
    end
  end
end
