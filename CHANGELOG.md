# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 3.0.0 - 2020-12-29

- Change from a static-based architecture (e.g., `Jahuty::Snippet.render(1)`) to an instance-based one (e.g., `jahuty.snippets.render(1)`) to make the library easier to develop, test, and use.
- Fix links in `README`.
- Add [CircleCI](https://circleci.com/gh/jahuty/jahuty-ruby) continuous integration.

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
