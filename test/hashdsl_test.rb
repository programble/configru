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
