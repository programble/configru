require 'teststrap'

context 'ConfigHash - ' do
  setup { Configru::ConfigHash.new }
  
  context 'empty' do
    asserts('[:quux]') { topic[:quux] }.nil
    asserts(:quux).nil
  end
  
  context 'non-empty' do
    hookup do
      topic.merge!({'foo' => 1, 'bar' => 2, 'baz' => 3})
    end
    
    # Testing access methods
    asserts("['foo']") { topic['foo'] }.equals(1)
    asserts('[:foo]') { topic[:foo] }.equals(1)
    asserts(:foo).equals(1)
  end
  
  context 'overwriting a value by merge' do
    hookup do
      topic.merge!({'foo' => 1, 'bar' => 2, 'baz' => 3})
      topic.merge!({'bar' => 4})
    end
    asserts(:bar).equals(4)
  end
  
  context 'merging a nested Hash' do
    hookup do
      topic.merge!({'foo' => 1, 'bar' => 2, 'baz' => 3})
      topic.merge!({'bar' => 4})
      topic.merge!({'baz' => {'quux' => 5}})
    end
    
    asserts(:baz).kind_of(Configru::ConfigHash)
    asserts('baz.quux') { topic.baz.quux }.equals(5)
  end
  
  context 'recursively merging a nested Hash' do
    hookup do
      topic.merge!({'foo' => 1, 'bar' => 2, 'baz' => 3})
      topic.merge!({'bar' => 4})
      topic.merge!({'baz' => {'quux'  => 5}})
      topic.merge!({'baz' => {'apple' => 6}})
    end
    
    asserts(:baz).kind_of(Configru::ConfigHash)
    asserts('baz.apple') { topic.baz.apple }.equals(6)
    asserts('baz.quux') { topic.baz.quux }.equals(5)
  end

  context 'keys with hyphens' do
    hookup do
      topic.merge!({'foo-bar-baz' => 1})
    end

    asserts('foo_bar_baz') { topic.foo_bar_baz }.equals(1)
    asserts('[:foo_bar_baz]') { topic[:foo_bar_baz] }.equals(1)
    asserts("['foo_bar_baz']") { topic['foo_bar_baz'] }.equals(1)
  end
end
