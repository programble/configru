# Configru

Versatile configuration file loader for Ruby

## Installation

    gem install configru

## Usage

Configru loads YAML configuration files and provides a simple way to access
configuration options.

### Loading Configuration Files

Configru provides a DSL for loading configuration files.

```ruby
require 'configru'

Configru.load do
  # Things
end
```

At the very least, the block passed to `Configru.load` must tell Configru which
files it should load. There are two different methods of loading configuration
files available.

#### Just load a file already!

This is the simplest method of loading. It just loads a file.

```ruby
Configru.load do
  just 'foo.yml'
end
```

#### First-of Loading

This method loads the first file that exists, ignoring all other files.

```ruby
Configru.load do
  first_of 'foo.yml', '~/foo.yml', '/etc/foo.yml'
end
```

#### Cascading Loading

This method loads every file that exists in reverse order. Files listed first
overwrite the values from files listed later. (Files are listed in high to low
cascade priority)

```ruby
Configru.load do
  cascade '~/foo.yml', '/etc/foo.yml'
end
```

### Accessing Options

Configuration options can be accessed as methods of the `Configru` module, or
`Configru` can be used as a Hash.

##### foo.yml
```yaml
nick: bob
server:
  address: foo.net
  port: 6782
```

##### foo.rb
```ruby
require 'configru'
require 'socket'

Configru.load do
  just 'foo.yml'
end

s = TCPSocket.new(Configru.server.address, Configru['server']['port'])
s.puts "Hello, I am #{Configru.nick}"
```

Configuration options with hyphens can be accessed as methods by replacing the
hyphens with underscores.

### Defaults

Configru's load DSL allows for setting configuration defaults using a block.
If no configuration files are found or if the configuration file omits an
option, the values in `defaults` will be used.


```ruby
require 'configru'

Configru.load do
  just 'foo.yml'
  defaults do
    nick 'Dr. Nader'
    server do
      address 'abcd.com'
      port 1111
    end
  end
end
```

The above `defaults` block is equivalent to the following YAML:

```yaml
nick: Dr. Nader
server:
  address: abcd.com
  port: 1111
```

Defaults can also be set using a Hash instead of a block.

```ruby
Configru.load do
  just 'foo.yml'
  defaults 'nick' => 'Dr. Nader',
           'server' => {'address' => 'abcd.com', 'port' => 1111}
end
```

Defaults can also be loaded from a YAML file by passing the filename to
`default`.

```ruby
Configru.load do
  just 'foo.yml'
  defaults 'foo.yml.dist'
end
```

### Verifying options

Configru provides a way to verify that configuration options meet certain
requirements. This is done using a `verify` block in `Configru.load`.

```ruby
Configru.load do
  just 'foo.yml'
  verify do
    foo Fixnum
    bar /^a+$/
    baz ['one', 'two']
  end
end
```

Upon loading the configuration, Configru checks each option against this verify
block. In most cases, the `===` operator is used to compare the values, but
there are some special cases. If the verification value is a class, `is_a?` is
used. If the verification value is an array, `include?` is used. This
effectively means that with a class, the value must be an instance of that
class, and with an array, the value must be one of the values in the array.

FIXME: Talk about how Configru deals with invalid options

### Doing two things at once

Configru also has an `options` block in `Configru.load` which allows for
combining the `defaults` and `verify` blocks.

```ruby
Configru.load do
  just 'foo.yml'
  options do
    nick String, 'Dr. Nader'
    server do
      address String, 'abcd.com'
      port (0..65535), 1111
    end
  end
end
```

In the `options` block, each option takes two arguments, the first being the
verification value, and the second being the default value.

## License

Copyright (c) 2011, Curtis McEnroe <programble@gmail.com>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

