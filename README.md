[![CircleCI](https://circleci.com/gh/jahuty/jahuty-ruby.svg?style=svg)](https://circleci.com/gh/jahuty/jahuty-ruby) [![codecov](https://codecov.io/gh/jahuty/jahuty-ruby/branch/master/graph/badge.svg?token=NLDCGGYB8S)](https://codecov.io/gh/jahuty/jahuty-ruby) [![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)

# jahuty-ruby

Welcome to the [Ruby SDK](https://docs.jahuty.com/sdks/ruby) for [Jahuty's API](https://docs.jahuty.com/api)!

## Installation

This library is tested with the following [Ruby versions](https://www.ruby-lang.org/en/downloads/releases/):

* MRI 2.6.8
* MRI 2.7.4
* MRI 3.0.2

It is multi-platform, and we strive to make it run equally well on Windows, Linux, and OSX.

To install, add this line to your application's `Gemfile` and run `bundle install`:

```ruby
gem 'jahuty', '~> 3.4'
```

## Usage

Instantiate the client with your [API key](https://docs.jahuty.com/api#authentication) and use `snippets.render` to render your snippet:

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')

puts jahuty.snippets.render YOUR_SNIPPET_ID
```

You can access the render's content with `to_s` or `content`:

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')

render = jahuty.snippets.render YOUR_SNIPPET_ID

render.to_s
render.content
```

In an HTML view:

```html+erb
<%- jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY') -%>
<!doctype html>
<html>
<head>
    <title>Awesome example</title>
</head>
<body>
    <%== jahuty.snippets.render YOUR_SNIPPET_ID %>
</body>
```

You can also use tags to render a collection of snippets with the `snippets.all_renders` method:

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')

renders = jahuty.snippets.all_renders 'YOUR_TAG'

renders.each { |r| puts r }
```

## Rendering content

By default, Jahuty will render a snippet's _published_ content, the content that existed the last time someone clicked the "Publish" button, to avoid exposing your creative process to customers.

You can use the `prefer_latest` configuration option, however, to render a snippet's _latest_ content, the content that currently exists in the editor. This allows you to render a snippet's _latest_ content to your team in _development_ and its _published_ content to your customers in _production_.

```ruby
jahuty = Jahuty::Client.new api_key: 'YOUR_API_KEY', prefer_latest: true
```

You can also prefer the latest content (or not) for a single render:

```ruby
# Render the _published_ content for all snippets...
jahuty = Jahuty::Client.new api_key: 'YOUR_API_KEY'

# ... except, render the _latest_ content for this one.
jahuty.snippets.render YOUR_SNIPPET_ID, prefer_latest: true
```

## Passing dynamic parameters

You can use the _same_ snippet to generate _different_ content by defining [variables](https://docs.jahuty.com/liquid/variables) in your snippets and setting their values via [parameters](https://docs.jahuty.com/liquid/parameters).

### Snippet parameters

Use the `params` option to pass parameters into your snippet:

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')

jahuty.snippets.render YOUR_SNIPPET_ID, params: { foo: 'bar' }
```

The parameters above would be equivalent to assigning the following variable in your snippet:

```html
{% assign foo = "bar" %}
```

### Collection parameters

Collection parameters use a slightly different syntax.

If you're rendering a collection, the first dimension of the `params` key determines the parameters' scope. Use an asterisk key (`*`) to pass the same parameters to all snippets, or use a snippet id as key to pass parameters to a specific snippet.

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')

jahuty.snippets.all_renders 'YOUR_TAG', params: {
  '*' => { foo: 'bar' },
  '1' => { baz: 'qux' }
}
```

This will pass the params `{ foo: 'bar' }` to all snippets, except for snippet `1`, which will be passed `{ foo: 'bar', baz: 'qux' }`.

The two parameter lists will be merged recursively, and parameters for a specific snippet will take precedence over parameters for all snippets. For example, the parameter `foo` will be assigned the value `"bar"` for all snippets, except for snippet `1`, where it will be assigned the value `"qux"`:

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')

jahuty.snippets.all_renders 'YOUR_TAG', params: {
  '*' => { foo: 'bar' },
  '1' => { foo: 'qux' }
}
```

## Tracking renders

You can record where snippets are rendered using the `location` configuration option. This helps your team preview their changes, and it helps you find and replace deprecated snippets.

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')

render = jahuty.snippets.render YOUR_SNIPPET_ID, location: 'https://example.com'
```

Note, this configuration option is only supported by the `render` method, not the `all_renders` method, and locations are only reported when a request is sent to Jahuty's API. As a result of this limitation, locations may not be reported in all scenarios. For example, if a call to `render` results in a cache hit, the location will not be reported.

## Caching for performance

You can use caching to control how frequently this library requests the latest content from Jahuty's API.

* When content is in _development_ (i.e., frequently changing and low traffic), you can use the default in-memory store to view content changes instantaneously with slower response times.
* When content is in _production_ (i.e., more stable and high traffic), you can use persistent caching to update content less frequently and improve your application's response time.

### Caching in memory (default)

By default, this library uses an in-memory cache to avoid requesting the same render more than once during the same request lifecycle. For example:

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY')

# This call will send a synchronous API request; cache the result in memory;
# and, return the result to the caller.
render1 = jahuty.snippets.render YOUR_SNIPPET_ID

# This call skips sending an API request and uses the cached value instead.
render2 = jahuty.snippets.render YOUR_SNIPPET_ID
```

The in-memory cache only persists for the duration of the original request, however. At the end of the request's lifecycle, the cache will be discarded. To store renders across requests, you need a persistent cache.

### Caching persistently

A persistent cache allows renders to be cached across multiple requests. This reduces the number of synchronous network requests to Jahuty's API and improves your application's average response time.

To configure Jahuty to use your persistent cache, pass a cache implementation to the client via the `cache` configuration option:

```ruby
jahuty = new Jahuty::Client.new(api_key: 'YOUR_API_KEY', cache: cache)
```

The persistent cache implementation you choose and configure is up to you. There are many libraries available, and most frameworks provide their own. At this time, we support any object which responds to `get(key)`/`set(key, value, expires_in:)` or `read(key)`/`write(key, value, expires_in:)` including [ActiveSupport::Cache::Store](https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-fetch).

### Expiring

There are three methods for configuring this library's `:expires_in`, the amount of time between when a render is stored and when it's considered stale. From lowest-to-highest precedence, the methods are:

1. configuring your caching implementation,
1. configuring this library's default `:expires_in`, and
1. configuring a render's `:expires_in`.

#### Configuring your caching implementation

You can usually configure your caching implementation with a default `:expires_in`. If no other `:expires_in` is configured, this library will defer to the caching implementation's default `:expires_in`.

#### Configuring this library's default `:expires_in`

You can configure a default `:expires_in` for all of this library's renders by passing an integer number of seconds via the client's `:expires_in` configuration option:

```ruby
 # Cache all renders for sixty seconds.
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY', cache: cache, expires_in: 60)
```

If this library's default `:expires_in` is set, it will take precedence over the default `:expires_in` of the caching implementation.

#### Configuring a render's `:expires_in`

You can configure `:expires_in` for individual renders by passing an integer number of seconds via the render method's `:expires_in` configuration option:

```ruby
# Cache all renders 300 seconds (five minutes).
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY', cache: cache, expires_in: 300)

# Except, cache this render for 60 seconds.
render = jahuty.snippets.render YOUR_SNIPPET_ID, expires_in: 60

# Except, cache the renders in this collection for 120 seconds.
render = jahuty.snippets.all_renders 'YOUR_TAG', expires_in: 120
```

If a render's `:expires_in` is set, it will take precedence over the library's default `:expires_in` and the caching implementation's `:expires_in`.

### Caching collections

By default, this library will cache each render returned by `all_renders`:

```ruby
jahuty = Jahuty::Client.new(api_key: 'YOUR_API_KEY', cache: cache)

# Sends a network request, caches each render, and returns the collection.
jahuty.snippets.all_renders 'YOUR_TAG'

# If this reder exists in the collection, the cached value will be used instead
# of sending a network request for the latest version.
jahuty.snippets.render YOUR_SNIPPET_ID
```

This is a powerful feature, especially when combined with a persistent cache. Using the `all_renders` method, you can render and cache an arbitrarily large chunk of content with a single network request. Because any subsequent call to `render` a snippet in the collection will use its cached version, you can reduce the number of network requests to load your content.

This method is even more powerful when combined with an asynchronous background job. When `all_renders` can be called outside your request cycle periodically, you can turn your cache into your content storage mechanism. You can render and cache dynamic content as frequently as you like without any hit to your application's response time.

### Disabling caching

You can disable caching, even the default in-memory caching, by passing an `:expires_in` of zero (`0`) or a negative integer (e.g., `-1`) via any of the methods described above. For example:

```ruby
# Disable all caching.
jahuty1 = Jahuty::Client.new(api_key: 'YOUR_API_KEY', expires_in: 0)

# Disable caching for this render.
jahuty2 = Jahuty::Client.new(api_key: 'YOUR_API_KEY', expires_in: 60)
jahuty2.snippets.render 1, expires_in: 0
```

## Handling errors

If an error occurs with [Jahuty's API](https://docs.jahuty.com/api#errors), a `Jahuty::Exception::Error` will be raised:

```ruby
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
