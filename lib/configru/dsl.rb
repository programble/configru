module Configru
  module DSL
    class LoadDSL
      attr_reader :defaults_hash, :verify_hash, :files_array, :load_method

      def initialize(block)
        @defaults_hash = {}
        @verify_hash = {}
        @files_array = []
        @load_method = :first
        instance_eval(&block)
      end

      def files(*args)
        if args[0].is_a?(String) && args[1].is_a?(Array)
          @files_array = args[1].map {|x| File.join(x, args[0])}
        else
          @files_array = args
        end
      end

      def method(m)
        @load_method = m
      end

      def first_of(*args)
        method(:first)
        files(*args)
      end

      alias :just :first_of

      def cascade(*args)
        method(:cascade)
        files(*args)
      end

      def defaults(arg=nil, &block)
        if arg.is_a? String
          @defaults_hash = YAML.load_file(arg)
        elsif arg
          @defaults_hash = arg
        elsif block
          @defaults_hash = HashDSL.new(block).hash
        end
      end

      def verify(hash=nil, &block)
        if hash
          @verify_hash = hash
        elsif block
          @verify_hash = HashDSL.new(block).hash
        end
      end

      def options(&block)
        hashes = DoubleHashDSL.new(block)
        @defaults_hash = hashes.hash2
        @verify_hash = hashes.hash1
      end
    end

    class HashDSL
      attr_reader :hash

      def initialize(block)
        @hash = {}
        instance_eval(&block)
      end

      def method_missing(method, *args, &block)
        key = method.to_s.gsub('_', '-')
        if block
          @hash[key] = HashDSL.new(block).hash
        else
          # Simulate method requiring 1 argument
          raise ArgumentError, "wrong number of arguments(#{args.length} for 1)" unless args.length == 1
          @hash[key] = args[0]
        end
      end
    end

    class DoubleHashDSL
      attr_reader :hash1, :hash2

      def initialize(block)
        @hash1 = {}
        @hash2 = {}
        instance_eval(&block)
      end

      def method_missing(method, *args, &block)
        key = method.to_s.gsub('_', '-')
        if block
          child = DoubleHashDSL.new(block)
          @hash1[key] = child.hash1
          @hash2[key] = child.hash2
        else
          # Simulate method requiring 2 arguments
          raise ArgumentError, "wrong number of arguments(#{args.length} for 2)" unless args.length == 2
          @hash1[key] = args[0]
          @hash2[key] = args[1]
        end
      end
    end
  end
end
