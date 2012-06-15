describe Configru::DSL::Option do
  before do
    @option = Configru::Option.new(:type, :default, :validate, :transform)
  end

  it 'sets option type' do
    described_class.new(@option) do
      type String
    end

    @option.type.should == String
  end

  it 'sets option default' do
    described_class.new(@option) do
      default 'Example'
    end

    @option.default.should == 'Example'
  end

  it 'sets option validate value' do
    described_class.new(@option) do
      validate /example/
    end

    @option.validate.should == /example/
  end

  it 'sets option validate block' do
    described_class.new(@option) do
      validate do
        :example
      end
    end

    @option.validate.should be_a(Proc)
    @option.validate.call.should == :example
  end

  it 'sets option transofmr block' do
    described_class.new(@option) do
      transform do
        :example
      end
    end

    @option.transform.should be_a(Proc)
    @option.transform.call.should == :example
  end
end

describe Configru::DSL::OptionGroup do
  it 'creates an option' do
    group = described_class.new do
      option 'example'
    end

    group.options.should have_key('example')
    group.options['example'].should be_a(Configru::Option)
  end

  it 'converts option names to strings' do
    group = described_class.new do
      option :example
    end

    group.options.should have_key('example')
  end

  it 'creates a default option' do
    group = described_class.new do
      option 'example'
    end

    group.options['example'].type.should == Object
    group.options['example'].default.should be_nil
    group.options['example'].validate.should be_nil
    group.options['example'].transform.should be_nil
  end

  it 'runs the Option DSL' do
    group = described_class.new do
      option 'example' do
        type String
      end
    end

    group.options['example'].type.should == String
  end

  it 'creates a group' do
    group = described_class.new do
      option_group 'example' do
        option 'nested'
      end
    end

    group.options['example'].should be_a(Hash)
    group.options['example'].should have_key('nested')
  end

  it 'converts group names to strings' do
    group = described_class.new do
      option_group :example do
      end
    end

    group.options.should have_key('example')
  end
end
