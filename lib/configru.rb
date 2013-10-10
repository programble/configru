require 'configru/config'

module Configru
  @raise_exceptions = false

  def self.raise_exceptions
    @raise_exceptions
  end

  def self.raise_exceptions=(x)
    @raise_exceptions = x
  end

  def self.load(*files, &block)
    @config = Config.new(*files, &block)
  rescue OptionError => e
    raise if @raise_exceptions
    $stderr.puts "Configuration error #{e.message}"
    exit 1
  end

  def self.method_missing(*args, &block)
    @config.send(*args, &block)
  end
end
