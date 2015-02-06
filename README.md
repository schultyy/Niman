# Niman

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'niman'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install niman

## Usage

It starts with a `Nimanfile`:

```ruby
file do |config|
  config.path = '/home/bob/hello.txt'
  config.content = 'hello from alice'
  config.mode = '0600'
end
```
This places a new file `hello.txt` in `/home/bob` with rights 0600.

A `Nimanfile` contains all necessary commands for `niman` to run.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/niman/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
