require 'teststrap'

context 'ConfigHash - ' do
  setup { Configru::ConfigHash.new }
  
  context 'empty' do
    asserts('[:quux]') { topic[:quux] }.nil
    asserts(:quux).nil
  end
  
  context 'non-empty' do
    hookup { topic.merge!({'foo' => 1, 'bar' => 2, 'baz' => 3}) }
    
    # Testing access methods
    asserts("['foo']") { topic['foo'] }.equals(1)
    asserts('[:foo]') { topic[:foo] }.equals(1)
    asserts(:foo).equals(1)
  end
  
  context 'overwriting a value by merge' do
    hookup { topic.merge!({'bar' => 4}) }
    asserts(:bar).equals(4)
  end
  
  context 'merging a nested Hash' do
    hookup { topic.merge!({'baz' => {'quux' => 5}}) }
    
    asserts(:baz).kind_of(Configru::ConfigHash)
    asserts('baz.quux') { topic.baz.quux }.equals(5)
  end
  
  context 'recursively merging a nested Hash' do
    hookup do
      topic.merge!({'baz' => {'quux'  => 5}})
      topic.merge!({'baz' => {'apple' => 6}})
    end
    
    asserts(:baz).kind_of(Configru::ConfigHash)
    asserts('baz.apple') { topic.baz.apple }.equals(6)
    asserts('baz.quux') { topic.baz.quux }.equals(5)
  end
end
