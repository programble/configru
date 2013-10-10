describe Configru do
  it 'behaves like Config' do
    Configru.load do
      option :example, String, 'example'
    end

    Configru['example'].should == 'example'
    Configru.example.should == 'example'
    expect { Configru.idonotexist }.to raise_error(NoMethodError)
  end

  it 'allows access to underlying Config object' do
    Configru.load { }
    Configru.config.should be_a(Configru::Config)
  end
end
