describe Configru do
  before do
    @stderr = $stderr
    @io = StringIO.new
    $stderr = @io
  end

  after do
    $stderr = @stderr
  end

  it 'behaves like Config' do
    Configru.load do
      option :example, String, 'example'
    end

    Configru['example'].should == 'example'
    Configru.example.should == 'example'
    expect { Configru.idonotexist }.to raise_error(NoMethodError)
  end

  it 'allows access to raise_exceptions' do
    Configru.raise_exceptions = false
    Configru.raise_exceptions.should == false
  end

  it 'raises exceptions' do
    Configru.raise_exceptions = true
    expect do
      Configru.load do
        option_required :example, String
      end
    end.to raise_error(Configru::OptionRequiredError)
  end

  it 'exits with message' do
    Configru.raise_exceptions = false
    expect do
      Configru.load do
        option_required :example, String
      end
    end.to raise_error(SystemExit)
    @io.string.should =~ /option required/
  end
end
