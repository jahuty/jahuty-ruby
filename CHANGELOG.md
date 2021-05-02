# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 3.3.1 - 2021-05-02

### Fixed

- Fixed [#19](https://github.com/jahuty/jahuty-ruby/issues/19) where renders were cached without regard for their content version.

## 3.3.0 - 2021-04-29

- Add the `prefer_latest` configuration option to the client and render methods. This setting allows you to render a snippet's _latest_ content instead of the default _published_ content.

## 3.2.1 - 2021-03-16

- Fix issue with double-enveloping the `params` query string parameter.
- Add system tests for params, caching, problems, and collections.

## 3.2.0 - 2021-03-08

- Added collections to the library with `all_renders` method. This was a rather large change and required adding new objects like `Action::Show`, refactoring old ones like `Resource::Factory`, and removing some objects like `Cache::Manager` and `Service::Factory` which added unnecessary complexity.
- Added `snippet_id` to `Resource::Render` to help keep track of a render's parent snippet.

## 3.1.1 - 2021-02-26

- Add support for extra, unused attributes returned by the API to support evolution.
- Fix the `method redefined` warnings in `cache/manager_spec.rb` and `cache/facade_spec.rb`.
- Fix the `expect { }.not_to raise_error(SpecificErrorClass)` false positives warnings in `resource/render_spec.rb`.

## 3.1.0 - 2021-01-04

- Add caching support for any cache implementation that supports `get/set` or `read/write` methods.
- Default to using in-memory [mini-cache](https://github.com/derrickreimer/mini_cache) storage.

## 3.0.0 - 2020-12-30

- Change from a static-based architecture (e.g., `Jahuty::Snippet.render(1)`) to an instance-based one (e.g., `jahuty.snippets.render(1)`) to make the library easier to develop, test, and use.
- Change `README` and fix broken links from `www.jahuty.com/docs` to `docs.jahuty.com`.
- Add [CircleCI](https://circleci.com/gh/jahuty/jahuty-ruby) continuous integration.
- Add [Rubocop](https://github.com/rubocop-hq/rubocop) code analyzer and formatter, based on the community style guide.
- Add code coverage analysis with [Simplecov](https://github.com/simplecov-ruby/simplecov) and [Codecov.io](https://codecov.io/gh/jahuty/jahuty-ruby).

## 2.0.0 - 2020-07-04

- Change `Service::Get` to `Service::Render`.
- Change `Snippet.get` to `Snippet.render`.
- Change optional second argument of `Snippet.render` from `params` hash to options hash with `params` key.
- Change `Data::Snippet` to `Data::Render`.
- Remove `id` attribute from `Data::Render`.
- Change API endpoint to `snippets/:id/render`.

## 1.1.2 - 2020-07-04

- Change the Faraday gem from `~> 0.1` to `~> 1.0`.

## 1.1.1 - 2020-03-15

- Change snippet parameters to JSON query string parameter (e.g., `params={"foo":"bar"}`) from serialized query string parameter (e.g.,`params[foo]=bar`).

## 1.1.0 - 2020-03-14

- Add snippet parameters.

## 1.0.0 - 2020-03-08

- Update `rake` version.
- Move API key to `Jahuty` object from `Snippet` object.
- Rename gem to `jahuty` from `jahuty-snippet`.
- Rename repository to `jahuty-ruby` from `snippets-ruby`.
- Add `CHANGELOG.md`.

## 0.1.0 - 2019-09-07

- Initial release
