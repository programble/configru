require 'configru/dsl'
require 'configru/option'
require 'configru/structhash'

require 'yaml'

module Configru
  class OptionError < RuntimeError
    def initialize(path, message)
      super("#{path.join('.')}: #{message}")
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

  def self.load(*files, &block)
    @files = files.flatten
    @options = DSL::OptionGroup.new(&block).options
    @root = StructHash.new
    self.reload
  end

  def self.reload
    loaded_files = []
    @files.each do |file|
      if File.file?(file) && !File.zero?(file)
        self.load_file(file)
        loaded_files << file
      end
    end

    # Load all defaults if no files were loaded
    # TODO: loaded_files as instance var?
    # TODO: Better way to load defaults?
    @option_path = []
    self.load_group(@options, @root, {}) if loaded_files.empty?
  end

  def self.load_file(file)
    @option_path = []
    self.load_group(@options, @root, YAML.load_file(file) || {})
  end

  def self.load_group(option_group, output, input)
    option_group.each do |key, option|
      @option_path << key

      # option is a group
      if option.is_a? Hash
        if input.has_key?(key) && !input[key].is_a?(Hash)
          raise OptionTypeError.new(@option_path, Hash, input[key].class)
        end
        group_output = output[key] || StructHash.new
        self.load_group(option, group_output, input[key] || {})
        output[key] = group_output
        @option_path.pop
        next
      end

      if input.include? key
        value = input[key]
      elsif output.include? key # option has already been set
        @option_path.pop
        next
      else # option has not been set
        value = option.default
      end

      unless option.type?(value)
        raise OptionTypeError.new(@option_path, option.type, value.class)
      end

      unless option.valid?(value)
        raise OptionValidationError.new(@option_path, option.validation)
      end

      output[key] = option.transform(value)

      @option_path.pop
    end
  end

  def self.[](key)
    @root[key]
  end

  def self.method_missing(method, *args)
    @root.send(method, *args)
  end
end
