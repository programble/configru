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

#### First-of Loading

This method of loading looks for each file given and loads the first one
that exists.

```ruby
Configru.load do
  first_of 'foo.yml', '~/foo.yml', '/etc/foo.yml'
end
```

#### Cascading Loading

This method of loading loads each file given (if it exists) and cascades
their values. The values in the first given file have highest priority,
and the values in the last file have lowest priority.

```ruby
Configru.load do
  cascade '~/foo.yml', '/etc/foo.yml'
end
```

This will load `/etc/foo.yml` first, then `~/foo.yml`. The values in
`~/foo.yml` will overwrite the values in `/etc/foo.yml`. If a configuration
option is omitted in `~/foo.yml`, it will default to the value in
`/etc/foo.yml`.

### Accessing Options

Configru aims to make accessing configuration values as simple as possible.
All configuration options can be accessed as methods on the module
`Configru`.

##### foo.yml
```yaml
name: bob
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
s.puts "Hello, I am #{Configru.name}"
```

Configuration options can also be accessed the old-fashioned way like a
Hash. `Configru['server']['port']` is equivalent to `Configru.server.port`.

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

