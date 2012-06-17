require 'configru/dsl'
require 'configru/option'
require 'configru/structhash'

require 'yaml'

module Configru
  class ConfigurationError < RuntimeError; end

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
    self.load_group(@options, @root, {}) if loaded_files.empty?
  end

  def self.load_file(file)
    self.load_group(@options, @root, YAML.load_file(file) || {})
  end

  def self.load_group(option_group, output, input)
    option_group.each do |key, option|
      # option is a group
      if option.is_a? Hash
        group_output = output[key] || StructHash.new
        self.load_group(option, group_output, input[key] || {})
        output[key] = group_output
        next
      end

      if input.include? key
        value = input[key]
      else
        value = option.default
      end

      # TODO: Better exceptions
      raise ConfigurationError unless value.is_a? option.type
      if option.validate.is_a? Proc
        raise ConfigurationError unless option.validate[value]
      elsif option.validate
        raise ConfigurationError unless option.validate === value
      end

      output[key] = option.transform ? option.transform[value] : value
    end
  end

  def self.[](key)
    @root[key]
  end

  def self.method_missing(method)
    @root.send(method)
  end
end
