%w[dsl option structhash exceptions].map {|r| require("configru/#{r}") }

require 'yaml'

module Configru
  class Config < StructHash
    def initialize(*files, &block)
      @files = files.flatten
      @dsl_block = block
      reload
    end

    def reload
      @options = DSL::OptionGroup.new(&@dsl_block).options

      loaded_files = Array.new
      @files.each do |file|
        if File.file?(file) && !File.zero?(file)
          load_file(file)
          loaded_files << file
        end
      end

      # Load all defaults if no files were loaded
      # TODO: Some way to not special case this
      @option_path = Array.new
      @file = '(none)'
      load_group(@options, self, {}) if loaded_files.empty?
    end

    def inspect
      "#<#{self.class} #{super}>"
    end

    private

    def load_file(file)
      @option_path = Array.new
      @file = file
      load_group(@options, self, YAML.load_file(file) || {})
    end

    def load_group(option_group, output, input)
      option_group.each do |key, option|
        @option_path << key

        # option is a group
        if option.is_a? Hash
          if input.has_key?(key) && !input[key].is_a?(Hash)
            raise OptionTypeError.new(@file, @option_path, Hash, input[key].class)
          end
          group_output = output[key] || StructHash.new
          load_group(option, group_output, input[key] || {})
          output[key] = group_output
          @option_path.pop
          next
        end

        if input.include? key
          value = input[key]
        elsif output.include? key # option has already been set
          @option_path.pop
          next
        elsif option.is_a? RequiredOption
          raise OptionRequiredError.new(@file, @option_path)
        else # option has not been set
          value = option.default
        end

        unless option.type?(value)
          raise OptionTypeError.new(@file, @option_path, option.type, value.class)
        end

        unless option.valid?(value)
          raise OptionValidationError.new(@file, @option_path, option.validation)
        end

        output[key] = option.transform(value)

        @option_path.pop
      end
    end
  end
end
