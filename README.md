# snippets-ruby
Jahuty's Ruby client.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'jahuty-snippet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jahuty-snippets

## Usage

Set your public API key:

```ruby
Jahuty::Snippet.key = '1a2b3c4d5e1a2b3c4d5e'
```

Then, use the `.get` method to fetch a snippet:

```html+erb
<!doctype html>
<html>
<head>
    <title>Ruby example</title>
</head>
<body>
    <%= Jahuty::Snippet.get(123); %>
</body>
```

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/jahuty/snippets-ruby).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
