# Configru [![Gem Version](https://badge.fury.io/rb/configru.png)](http://badge.fury.io/rb/configru) [![Build Status](https://secure.travis-ci.org/programble/configru.png?branch=master)](http://travis-ci.org/programble/configru) [![Coverage Status](https://coveralls.io/repos/programble/configru/badge.png)](https://coveralls.io/r/programble/configru)

YAML configuration file loader

## Usage

Install the gem or add it to your `Gemfile`:

```ruby
gem 'configru', '~> 3.6.0'
```

Next, require it and load a configuration:

```ruby
require 'configru'

config = Configru::Config.new('config.yml')
```

This example loads `config.yml` if it exists. Or at least it would, if
we told Configru the configuration options we wanted to load.

### Options

Configru provides a DSL for specifying the options that should be
loaded. The main method to specify configuration options is `option`.

```ruby
config = Configru::Config.new('config.yml') do
  option :username, String, 'example_user', /^[A-Za-z1-9_]+$/
end
```

`option` takes 4 arguments: the configuration key, the type of value,
the default value, and a validation check. The type defaults to
`Object`, the default value defaults to `nil` and the validation check
defaults to nothing. Note that a value of `nil` will be treated as the
correct type regardless of the specified type.

The configuration option above can then be accessed in two ways:

```ruby
config.username
config['username']
```

If the value in `config.yml` is not a `String`, a
`Configru::OptionTypeError` will be raised. If the value does not pass
the validation check, a `Configru::OptionValidationError` will be
raised.

### Validation

Validations are checked against the value of the option using the `===`
operator. This allows validations to be Procs, Regexps and Ranges. If
the validation is an Array, the value is checked using `include?`.

`option` can also be passed a block which can be used to set the
validation for the option. This allows a more convenient way to write
Proc validations.

```ruby
config = Configru::Config.new('config.yml') do
  option :username, String, 'example_user' do
    validate {|o| o.length < 255 }
  end
end
```

### Transformation

Configru also allows options to be transformed (using a Proc) as they
are loaded.

```ruby
config = Configru::Config.new('config.yml') do
  option :username, String, 'example' do
    transform {|o| o + '_user' }
  end
end
```

In the above example, if the username set in `config.yml` is
"winnifred", it will be transformed using the Proc and `config.username`
will be `"winnifred_user"`.

### Required options

For configuration options that have no default and must be set in the
loaded configuration file, there is `option_required`. It takes the same
arguments as `option`, except for a default value.

```ruby
config = Configru::Config.new('config.yml') do
  option_required :username, String
end
```

If a required option is not set in the loaded file, a
`Configru::OptionRequiredError` will be raised.

### Array options

For options whose value should be a list, there is `option_array`. It
takes the same arguments as `option`, except the default value is
optional and defaults to an empty array. It behaves in the same way as
`option` except each element of the array is checked against the type
and the validation, and each element is transformed using the
transformation Proc.

```ruby
config = Configru::Config.new('config.yml') do
  option_array :users, String, ['user1', 'user2']
end
```

### Boolean options

Since Ruby's `true` and `false` do not share a class such as `Boolean`,
Configru provides a convenience method for boolean options,
`option_bool`. It takes only an option key and a default value as
arguments.

```ruby
config = Configru::Config.new('config.yml') do
  option_bool :debug, false
end
```

The above example is equivalent to the following:

```ruby
config = Configru::Config.new('config.yml') do
  option :debug, Object, false, [true, false]
end
```

(This works because Array validations are checked using `include?`)

### Option groups

Configru allows nesting options in groups.

```ruby
config = Configru::Config.new('config.yml') do
  option_group :user do
    option_required :name, String
    option_required :password, String
  end
end
```

The format for the configuration file would be:

```yaml
user:
  name: example
  password: example
```

The above options can then be accessed using either method described
above:

```ruby
config.user.name
config.user.password
config['user']['name']
config['user']['password']
```

Option groups can, of course, be nested in other option groups.

### Loading multiple files

Multiple files can be passed to `Configru::Config.new` and each will be
loaded sequentially, replacing any values from previous files with new
ones. This allows for loading a global configuration file and a user
configuration file that can override the global configuration.

```ruby
config = Configru::Config.new('/etc/config.yml', File.expand_path('~/config.yml')) do
  option :username, String, 'example_user'
end
```

### Reloading

To reload configuration files, call the `reload` method on the
`Configru::Config` object. Note that the entire DSL block will be
re-evaluated.

```ruby
config = Configru::Config.new('config.yml') do
  option :username, String, 'example_user'
end

config.reload
```

### Global loading

Since it can be tedious to pass around the `config` object all over an
application in order to have access to the configuration, the `Configru`
module itself can be used a `Configru::Config` object with the `load`
method.

```ruby
Configru.load('config.yml') do
  option :username, String, 'example_user'
end
```

Option values can then be accessed on the `Configru` module in the same
way as on a `Configru::Config` object:

```ruby
Configru.username
Configru['username']
```

The global configuration can also be reloaded in the same way:

```ruby
Configru.reload
```

Access to the underlying `Configru::Config` object of the global
configuration is provided:

```ruby
Configru.config
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

