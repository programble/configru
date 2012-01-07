require 'teststrap'
require 'configru/dsl'

context 'LoadDSL - Files' do
  setup do
    block = proc do
      cascade 'a', 'b', 'c'
    end
    Configru::DSL::LoadDSL.new(block).files_array
  end

  asserts_topic.equals(['a', 'b', 'c'])
end

context 'LoadDSL - File-directories' do
  setup do
    block = proc do
      cascade 'a', ['b', 'c']
    end
    Configru::DSL::LoadDSL.new(block).files_array
  end

  asserts_topic.equals([File.join('b', 'a'), File.join('c', 'a')])
end
