$: << File.dirname(__FILE__) unless $:.include?(File.dirname(__FILE__))

require 'configru/confighash'
require 'configru/dsl'

require 'yaml'

module Configru
  class ConfigurationError < RuntimeError; end

  def self.load(&block)
    dsl = DSL::LoadDSL.new(block)
    @search_paths = dsl.search_array
    @defaults = dsl.defaults_hash
    @verify = dsl.verify_hash
    self.reload
  end
  
  def self.reload
    @config = ConfigHash.new(@defaults)
    
    @search_paths.each do |file|
      file = File.expand_path(file)
      if File.exist? file
        @config.merge!(YAML.load_file(file))
        break
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
      
      raise ConfigurationError, "Configuration option #{@verify_stack.reverse.join('.')} is invalid" unless result
      
      @verify_stack.shift
    end
  end
  
  def self.[](key)
    @config[key]
  end
  
  def self.method_missing(key, *args)
    self[key]
  end
end
