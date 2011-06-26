module Configru
  module DSL
    class LoadDSL
      attr_reader :defaults_hash, :verify_hash, :files_array, :load_method
      
      def initialize(block)
        @defaults_hash = {}
        @verify_hash = {}
        @files_array = []
        @load_method = :derp
        instance_eval(&block)
      end
      
      def search(*args)
        @files_array = args
      end
      
      def defaults(hash=nil, &block)
        if hash
          @defaults_hash = hash
        elsif block
          @defaults_hash = HashDSL.new(block).hash
        end
      end
      
      def defaults=(hash)
        @defaults_hash = hash
      end
      
      def verify(hash=nil, &block)
        if hash
          @verify_hash = hash
        elsif block
          @verify_hash = HashDSL.new(block).hash
        end
      end
      
      def verify=(hash)
        @verify_hash = hash
      end
    end
    
    class HashDSL
      attr_reader :hash
      
      def initialize(block)
        @hash = {}
        instance_eval(&block)
      end
      
      def method_missing(method, *args, &block)
        key = method.to_s
        if block
          @hash[key] = HashDSL.new(block).hash
        else
          @hash[key] = args[0]
        end
      end
    end
  end
end
