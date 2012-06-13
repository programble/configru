require 'configru/dsl'
require 'configru/option'
require 'configru/structhash'

require 'yaml'

module Configru
  class ConfigurationError < Exception; end

  def self.load(*files, &block)
    @files = files
    @options = DSL::OptionGroup.new(block).options
    @root = StructHash.new
    self.reload
  end

  def self.reload
    loaded_files = []
    @files.each do |file|
      if File.file?(file)
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

      # option has no value
      unless input.include? key
        output[key] = option.default
        next
      end

      value = input[key]

      # TODO: Better exceptions
      raise ConfigurationError unless value.is_a? option.type
      if option.validate
        raise ConfigurationError unless option.validate[value]
      end

      output[key] = option.transform ? option.transform[value] : value
    end
  end

  def self.method_missing(method)
    @root.send(method)
  end
end
