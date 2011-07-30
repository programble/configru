require 'teststrap'
require 'configru/dsl'

context 'HashDSL - flat' do
  setup do
    block = proc do
      foo 1
      bar 2
    end
    Configru::DSL::HashDSL.new(block).hash
  end

  asserts_topic.equals({'foo' => 1, 'bar' => 2})
end

context 'HashDSL - nested' do
  setup do
    block = proc do
      foo 1
      bar do
        baz 2
        quux 3
      end
    end
    Configru::DSL::HashDSL.new(block).hash
  end

  asserts_topic.equals({'foo' => 1, 'bar' => {'baz' => 2, 'quux' => 3}})
end

context 'HashDSL - keys with underscores' do
  setup do
    block = proc do
      foo_bar 1
      baz_quux 2
    end
    Configru::DSL::HashDSL.new(block).hash
  end

  asserts_topic.equals({'foo-bar' => 1, 'baz-quux' => 2})
end

context 'DoubleHashDSL - flat' do
  setup do
    block = proc do
      foo 1, 2
      bar 3, 4
    end
    Configru::DSL::DoubleHashDSL.new(block)
  end

  asserts(:hash1).equals({'foo' => 1, 'bar' => 3})
  asserts(:hash2).equals({'foo' => 2, 'bar' => 4})
end

context 'DoubleHashDSL - nested' do
  setup do
    block = proc do
      foo 1, 2
      bar do
        baz 3, 4
        quux 5, 6
      end
    end
    Configru::DSL::DoubleHashDSL.new(block)
  end

  asserts(:hash1).equals({'foo' => 1, 'bar' => {'baz' => 3, 'quux' => 5}})
  asserts(:hash2).equals({'foo' => 2, 'bar' => {'baz' => 4, 'quux' => 6}})
end

context 'DoubleHashDSL - keys with underscores' do
  setup do
    block = proc do
      foo_bar 1, 2
      baz_quux 3, 4
    end
    Configru::DSL::DoubleHashDSL.new(block)
  end

  asserts(:hash1).equals({'foo-bar' => 1, 'baz-quux' => 3})
  asserts(:hash2).equals({'foo-bar' => 2, 'baz-quux' => 4})
end
