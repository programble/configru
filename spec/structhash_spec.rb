describe Configru::StructHash do
  before do
    @hash = Configru::StructHash.new
  end

  it 'is a hash' do
    @hash.should be_a_kind_of(Hash)
  end

  it 'raises NoMethodError for missing method key' do
    expect { @hash.example }.to raise_error(NoMethodError)
  end

  it 'raises NoMethodError if method key exists but is called with arguments' do
    @hash['example'] = :example
    expect { @hash.example(:foo) }.to raise_error(NoMethodError)
  end

  it 'returns value for method key' do
    @hash['example'] = :example
    @hash.example.should == :example
  end
end
