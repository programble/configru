describe Configru do
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
    Configru.load('spec/examples_files/example_z.yml') do
      option :example, String, 'example'
    end

    Configru.example.should == 'example'
  end

  it 'loads defaults if file is empty' do
    Configru.load('spec/examples_files/example_e.yml') do
      option :example, String, 'example'
    end

    Configru.example.should == 'example'
  end

  it 'loads a file' do
    Configru.load('spec/example_files/example_a.yml') do
      option :example
    end

    Configru.example.should == 'example_a'
  end

  it 'loads files in order' do
    Configru.load('spec/example_files/example_a.yml', 'spec/example_files/example_b.yml') do
      option :example
    end

    Configru.example.should == 'example_b'
  end

  it 'loads a file with a group' do
    Configru.load('spec/example_files/example_c.yml') do
      option_group :example_group do
        option :example
      end
    end

    Configru.example_group.example.should == 'example_c'
  end

  it 'checks option types' do
    expect do
      Configru.load('spec/example_files/example_d.yml') do
        option :string, String, ''
      end
    end.to raise_error(Configru::ConfigurationError)
  end

  it 'validates options against values' do
    expect do
      Configru.load('spec/example_files/example_d.yml') do
        option :example, String, 'test', /test/
      end
    end.to raise_error(Configru::ConfigurationError)
  end

  it 'validates options against blocks' do
    expect do
      Configru.load('spec/example_files/example_d.yml') do
        option :example, String, '' do
          validate { false }
        end
      end
    end.to raise_error(Configru::ConfigurationError)
  end

  it 'applies transformations to options' do
    Configru.load('spec/example_files/example_d.yml') do
      option :example, String, '' do
        transform {|x| x + 't' }
      end
    end

    Configru.example.should == 'example_dt'
  end
end
