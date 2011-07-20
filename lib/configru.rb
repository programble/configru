$: << File.dirname(__FILE__) unless $:.include?(File.dirname(__FILE__))

require 'configru/confighash'
require 'configru/dsl'

require 'yaml'

module Configru
  class ConfigurationError < RuntimeError; end

  def self.load(load_method=:first, files=[], defaults={}, verify={}, &block)
    if block
      dsl = DSL::LoadDSL.new(block)
      @load_method = dsl.load_method
      @files = dsl.files_array.map {|x| File.expand_path(x)}
      @defaults = dsl.defaults_hash
      @verify = dsl.verify_hash
    else
      @load_method = load_method
      @files = files
      @defaults = defaults
      @verify = verify
    end
    self.reload
  end
  
  def self.reload
    @config = ConfigHash.new(@defaults)
    @loaded_files = []
    
    case @load_method
    when :first
      if file = @files.find {|file| File.file?(file)} # Intended
        @config.merge!(YAML.load_file(file) || {})
        @loaded_files << file
      end
    when :cascade
      @files.reverse_each do |file|
        if File.file?(file)
          @config.merge!(YAML.load_file(file) || {})
          @loaded_files << file
        end
      end
    end
    
    self.verify(@config, @verify)
  end
  
  @verify_stack = []
  def self.verify(hash, criteria)
    hash.each do |key, value|
      next unless criteria[key]
      @verify_stack.unshift(key)
      
      result = case criteria[key]
      when Hash
        self.verify(value, criteria[key])
        true
      when Class
        value.is_a?(criteria[key])
      when Array
        criteria[key].include?(value)
      else
        criteria[key] === value
      end
      
      raise ConfigurationError, "configuration option '#{@verify_stack.reverse.join('.')}' is invalid" unless result
      
      @verify_stack.shift
    end
  end

  def self.loaded_files
    @loaded_files
  end
  
  def self.[](key)
    @config[key]
  end
  
  def self.method_missing(key, *args)
    # Simulate NoMethodError if it looks like they really wanted a method
    raise NoMethodError, "undefined method `#{key.to_s}' for #{self.inspect}:#{self.class}" unless args.empty?
    self[key]
  end
end
