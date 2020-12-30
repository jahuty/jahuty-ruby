[![CircleCI](https://circleci.com/gh/jahuty/jahuty-ruby.svg?style=svg)](https://circleci.com/gh/jahuty/jahuty-ruby) [![codecov](https://codecov.io/gh/jahuty/jahuty-ruby/branch/master/graph/badge.svg?token=NLDCGGYB8S)](https://codecov.io/gh/jahuty/jahuty-ruby) [![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)

# jahuty-ruby

Welcome to the [Ruby SDK](https://docs.jahuty.com/sdks/ruby) for [Jahuty's API](https://docs.jahuty.com/api)!

## Installation

This library requires [Ruby 2.6+](https://www.ruby-lang.org/en/downloads/releases/).

It is multi-platform, and we strive to make it run equally well on Windows, Linux, and OSX.

Add this line to your application's `Gemfile`:

```ruby
gem 'jahuty', '~> 3.0'
```

## Usage

Instantiate the client with your [API key](https://docs.jahuty.com/api#authentication) and use `snippets.render()` to render your snippet:

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')

puts jahuty.snippets.render(YOUR_SNIPPET_ID)
```

You can also access the render's content with `to_s` or `content`:

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')

render = jahuty.snippets.render(YOUR_SNIPPET_ID)

a = render.to_s

b = render.content

a == b  # returns true
```

In an HTML view:

```html+erb
<%-
  jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')
%>
<!doctype html>
<html>
<head>
    <title>Awesome example</title>
</head>
<body>
    <%= jahuty.snippets.render YOUR_SNIPPET_ID %>
</body>
```

## Parameters

You can [pass parameters](https://docs.jahuty.com/liquid/parameters) into your snippet using the `params` option:

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')

jahuty.snippets.render(YOUR_SNIPPET_ID, params: { foo: 'bar' });
```

The parameters above would be equivalent to [assigning the variable](https://docs.jahuty.com/liquid/variables) below in your snippet:

```html
{% assign foo = "bar" %}
```

## Errors

If an error occurs with [Jahuty's API](https://docs.jahuty.com/api#errors), a `Jahuty::Exception::Error` will be raised:

```ruby
require 'jahuty'

begin
  jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')
  jahuty.snippets.render YOUR_SNIPPET_ID
rescue Jahuty::Exception::Error => e
  # The API returned an error. See the error's problem for details.
  puts e.problem.type    # a URL to more information
  puts e.problem.status  # the status code
  puts e.problem.detail  # a description of the error
end
```

That's it!

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/jahuty/snippets-ruby).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
