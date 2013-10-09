module Configru
  class OptionError < RuntimeError
    def initialize(path, message)
      super("#{path.join('.')}: #{message}")
    end
  end

  class OptionRequiredError < OptionError
    def initialize(path)
      super(path, 'option required')
    end
  end

  class OptionTypeError < OptionError
    def initialize(path, expected, got)
      super(path, "expected #{expected}, got #{got}")
    end
  end

  class OptionValidationError < OptionError
    def initialize(path, validation = nil)
      if validation.is_a?(Proc)
        super(path, "failed validation")
      else
        super(path, "failed validation `#{validation.inspect}`")
      end
    end
  end
end
