module Configru
  class OptionError < RuntimeError
    def initialize(file, path, message)
      super("in #{file} at #{path.join('.')}: #{message}")
    end
  end

  class OptionRequiredError < OptionError
    def initialize(file, path)
      super(file, path, 'option required')
    end
  end

  class OptionTypeError < OptionError
    def initialize(file, path, expected, got)
      super(file, path, "expected #{expected}, got #{got}")
    end
  end

  class OptionValidationError < OptionError
    def initialize(file, path, validation)
      if validation.is_a?(Proc)
        super(file, path, 'failed validation')
      else
        super(file, path, "failed validation `#{validation.inspect}`")
      end
    end
  end
end
