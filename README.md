# jahuty-ruby
Welcome to [Jahuty's](https://www.jahuty.com) Ruby SDK!

## Installation

This library requires [Ruby 2.3+](https://www.ruby-lang.org/en/downloads/releases/).

It is multi-platform, and we strive to make it run equally well on Windows, Linux, and OSX.

Add this line to your application's `Gemfile`:

```ruby
gem "jahuty", "~> 2.0"
```

And then execute:

```bash
$ bundle
```

## Usage

Before use, the library needs to be configured with your [API key](https://www.jahuty.com/docs/api#authentication) (ideally, once during startup):

```ruby
require "jahuty"

Jahuty.key = "YOUR_API_KEY"
```

With the API key set, you can use the `Snippet.render` method to render a snippet:

```ruby
require "jahuty"

# retrieve the snippet
render = Snippet.render YOUR_SNIPPET_ID

# convert it to a string
render.to_s

# or, access its attributes
render.content
```

In an HTML view:

```html+erb
<%-
require "jahuty"  

Jahuty.key = "YOUR_API_KEY"
%>
<!doctype html>
<html>
<head>
    <title>Awesome example</title>
</head>
<body>
    <%= Snippet.render YOUR_SNIPPET_ID %>
</body>
```

## Parameters

You can [pass parameters](https://www.jahuty.com/docs/passing-a-parameter) into your snippet using the `params` key of the options hash:

```ruby
require "jahuty"

Snippet.render(YOUR_SNIPPET_ID, params: { foo: "bar" });
```

The parameters above would be equivalent to [assigning the variables](https://www.jahuty.com/docs/assigning-a-variable) below in your snippet:

```html
{% assign foo = "bar" %}
```

## Errors

If you don't set your API key before calling `Snippet.render`, a `StandardError` will be raised. If an error occurs with [Jahuty's API](https://www.jahuty.com/docs/api), a `NotOk` exception will be raised:

```ruby
require "jahuty"

begin
  Snippet.render YOUR_SNIPPET_ID
rescue StandardError => e
  # hmm, did you set the API key first?
rescue Jahuty::Exception::NotOk => e
  # hmm, the API returned something besides 2xx status code
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
