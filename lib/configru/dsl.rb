require 'configru/option'

module Configru
  module DSL
    class OptionGroup
      attr_reader :options

      def initialize(&block)
        @options = {}
        instance_eval(&block)
      end

      def option(name, type = Object, default = nil, validation = nil, &block)
        option = Configru::Option.new(type, default, validation, nil)
        Option.new(option, &block) if block
        @options[name.to_s] = option
      end

      def option_array(name, type = Object, default = [], validation = nil, &block)
        option = Configru::OptionArray.new(type, default, validation, nil)
        Option.new(option, &block) if block
        @options[name.to_s] = option
      end

      def option_group(name, &block)
        @options[name.to_s] = OptionGroup.new(&block).options
      end
    end

    class Option
      def initialize(option, &block)
        @option = option
        instance_eval(&block)
      end

      def type(t)
        @option.type = t
      end

      def default(d)
        @option.default = d
      end

      def validate(v = nil, &block)
        @option.validation = v || block
      end

      def transform(&block)
        @option.transformation = block
      end
    end
  end
end
