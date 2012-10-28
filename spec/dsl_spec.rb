describe Configru::DSL::RequiredOption do
  before do
    @option = Configru::RequiredOption.new(:type, :validation, :transformation)
  end

  it 'sets option type' do
    described_class.new(@option) do
      type String
    end

    @option.type.should == String
  end

  it 'sets option validate value' do
    described_class.new(@option) do
      validate /example/
    end

    @option.validation.should == /example/
  end

  it 'sets option validate block' do
    described_class.new(@option) do
      validate do
        :example
      end
    end

    @option.validation.should be_a(Proc)
    @option.validation.call.should == :example
  end

  it 'sets option transform block' do
    described_class.new(@option) do
      transform do
        :example
      end
    end

    @option.transformation.should be_a(Proc)
    @option.transformation.call.should == :example
  end
end

describe Configru::DSL::Option do
  before do
    @option = Configru::Option.new(:type, :default, :validation, :transformation)
  end

  it 'sets option default' do
    described_class.new(@option) do
      default 'Example'
    end

    @option.default.should == 'Example'
  end
end

describe Configru::DSL::OptionGroup do
  it 'creates an option' do
    group = described_class.new do
      option 'example'
    end

    group.options.should have_key('example')
    group.options['example'].should be_a(Configru::Option)
    group.options['example'].type.should == Object
    group.options['example'].default.should be_nil
    group.options['example'].validation.should be_nil
    group.options['example'].transformation.should be_nil
  end

  it 'converts option names to strings' do
    group = described_class.new do
      option :example
    end

    group.options.should have_key('example')
  end

  it 'creates a required option' do
    group = described_class.new do
      option_required 'example'
    end

    group.options.should have_key('example')
    group.options['example'].should be_a(Configru::RequiredOption)
    group.options['example'].type.should == Object
    group.options['example'].validation.should be_nil
    group.options['example'].transformation.should be_nil
  end

  it 'converts required option names to strings' do
    group = described_class.new do
      option_required :example
    end

    group.options.should have_key('example')
  end

  it 'creates an option array' do
    group = described_class.new do
      option_array 'example'
    end

    group.options.should have_key('example')
    group.options['example'].should be_a(Configru::OptionArray)
    group.options['example'].type.should == Object
    group.options['example'].default.should == []
    group.options['example'].validation.should be_nil
    group.options['example'].transformation.should be_nil
  end

  it 'converts option array names to strings' do
    group = described_class.new do
      option_array :example
    end

    group.options.should have_key('example')
  end

  it 'runs the Option DSL' do
    group = described_class.new do
      option 'example' do
        type String
      end
      option_array 'example_array' do
        type String
      end
    end

    group.options['example'].type.should == String
    group.options['example_array'].type.should == String
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
