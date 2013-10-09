# Configru [![Gem Version](https://badge.fury.io/rb/configru.png)](http://badge.fury.io/rb/configru) [![Build Status](https://secure.travis-ci.org/programble/configru.png?branch=master)](http://travis-ci.org/programble/configru) [![Coverage Status](https://coveralls.io/repos/programble/configru/badge.png)](https://coveralls.io/r/programble/configru) [![Dependency Status](https://gemnasium.com/programble/configru.png?travis)](https://gemnasium.com/programble/configru)

YAML configuration file loader

## Usage

```ruby
# Gemfile
gem "configru", "~> 3.3.0"
```
### Example

```ruby
require 'configru'

Configru.load('config.yml') do
  option :username, String, 'example_user'
  option_required :token, Fixnum
  option_group :connection do
    option :server, String, 'example.com'
    option :port, Fixnum, 42
  end
  option :path, String, Dir.home do
    transform {|x| File.expand_path(x) }
    validate {|x| File.directory?(x) }
  end
  option_array :channels, String, ['foo', 'bar']
  option_bool :force, false
end

example = Example.new(Configru.connection.server, Configru.connection.port)
example.login(Configru.username, Configru.token)
Configru.channels.each do |x|
  example.sync(x, Configru.path, :force => Configru.force)
end
```

These defaults are equivalent to the following YAML:

```yaml
username: example_user
connection:
  server: example.com
  port: 42
path: ~
channels:
  - foo
  - bar
force: false
```

# License

Copyright © 2011-2013, Curtis McEnroe <programble@gmail.com>

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

