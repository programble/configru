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

At the very least, the block passed to `Configru.load` must tell Configru
which files it should load. There are two different methods of loading
configuration files available.

#### Just load a file already!

This is the simplest method of loading. It just loads a file, already!

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
overwrite the values from files listed later.

```ruby
Configru.load do
  cascade '~/foo.yml', '/etc/foo.yml'
end
```

### Accessing Options

Configru aims to make accessing configuration values as simple as possible.
All configuration options can be accessed as methods on the module
`Configru`.

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
  first_of 'foo.yml', '~/foo.yml'
end

s = TCPSocket.new(Configru.server.address, Configru.server.port)
s.puts "Hello, I am #{Configru.nick}"
```

Configuration options can also be accessed the old-fashioned way like a
Hash. `Configru['server']['port']` is equivalent to `Configru.server.port`.

Configuration optiosn with hyphens (ie. `foo-bar`) can be accessed either
using the old-fashioned way (ie. `Configru['foo-bar']`), or by replacing
the hyphens with underscores for the method way (ie. `Configru.foo_bar`).

### Defaults

Configru's load DSL allows for setting configuration defaults.

```ruby
require 'configru'

Configru.load do
  first_of 'foo.yml', '~/foo.yml'
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

If no configuration files are found or if the configuration file omits an
option, the values in `defaults` will be used.

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

