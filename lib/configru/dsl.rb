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

      def first_of(*args)
        @load_method = :first
        @files_array = args
      end

      alias :just :first_of
      
      def cascade(*args)
        @load_method = :cascade
        @files_array = args
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
