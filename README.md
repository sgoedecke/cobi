# Cobi

Cobi is a terminal menu library loosely inspired by COBOL's `SCREEN SECTION`. It aims to be (a) as simple as possible to use, and (b) to be a better user experience than the conversational menus that almost every generator uses: users should be able to see all the questions immediately, and navigate around your answers before submitting.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cobi'
```

## Usage

See `bin/demo` for an example. Initialize a new `Cobi::Screen`, attach some headings or fields to it, then call `run` to display it.

It's significantly less powerful than COBOL's `SCREEN SECTION` by design.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
