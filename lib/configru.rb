require 'configru/config'

module Configru
  def self.load(*files, &block)
    @config = Config.new(*files, &block)
  end

  def self.method_missing(*args, &block)
    @config.send(*args, &block)
  end
end
