describe Configru::StructHash do
  before do
    @hash = Configru::StructHash.new
  end

  it 'is a hash' do
    @hash.should be_a_kind_of(Hash)
  end

  it 'returns nil for missing method key' do
    @hash.example.should be_nil
  end

  it 'returns value for method key' do
    @hash['example'] = :example
    @hash.example.should == :example
  end
end
