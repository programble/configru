describe Configru do
  def example_file(x)
    "spec/example_files/example_#{x}.yml"
  end

  it 'loads defaults if no files are given' do
    Configru.load do
      option :example, String, 'example'
    end

    Configru.example.should == 'example'
  end

  it 'behaves like a hash' do
    Configru.load do
      option :example, String, 'example'
    end

    Configru['example'].should == 'example'
  end

  it 'loads defaults if no files exist' do
    Configru.load(example_file :z) do
      option :example, String, 'example'
    end

    Configru.example.should == 'example'
  end

  it 'loads defaults if file is empty' do
    Configru.load(example_file :e) do
      option :example, String, 'example'
    end

    Configru.example.should == 'example'
  end

  it 'loads defaults if file contains only whitespace' do
    Configru.load(example_file :f) do
      option :example, String, 'example'
    end

    Configru.example.should == 'example'
  end

  it 'loads a file' do
    Configru.load(example_file :a) do
      option :example
    end

    Configru.example.should == 'example_a'
  end

  it 'loads files in order' do
    Configru.load(example_file(:a), example_file(:b)) do
      option :example
    end

    Configru.example.should == 'example_b'
  end

  it 'loads a file with a group' do
    Configru.load(example_file :c) do
      option_group :example_group do
        option :example
      end
    end

    Configru.example_group.example.should == 'example_c'
  end

  it 'checks that group values are Hashes' do
    expect do
      Configru.load(example_file :a) do
        option_group :example do
        end
      end
    end.to raise_error(Configru::OptionTypeError)
  end

  it 'checks option types' do
    expect do
      Configru.load(example_file :d) do
        option :string, String, ''
      end
    end.to raise_error(Configru::OptionTypeError)
  end

  it 'validates options against values' do
    expect do
      Configru.load(example_file :d) do
        option :example, String, 'test', /test/
      end
    end.to raise_error(Configru::OptionValidationError)
  end

  it 'validates options against blocks' do
    expect do
      Configru.load(example_file :d) do
        option :example, String, '' do
          validate { false }
        end
      end
    end.to raise_error(Configru::OptionValidationError)
  end

  it 'applies transformations to options' do
    Configru.load(example_file :d) do
      option :example, String, '' do
        transform {|x| x + 't' }
      end
    end

    Configru.example.should == 'example_dt'
  end
end
