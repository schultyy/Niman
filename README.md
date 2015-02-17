# Niman
[![Build Status](https://travis-ci.org/schultyy/Niman.svg?branch=master)](https://travis-ci.org/schultyy/Niman)

Niman is a proof-of-concept provisioner.

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
Niman::Recipe.configure do |config|
  config.file '/home/bob/hello.txt' do |file|
    file.content = 'hello from alice'
  end
end
```
This places a new file `hello.txt` in `/home/bob` with rights 0600.

A `Nimanfile` contains all necessary commands for `niman` to run.

### Packages

Use a concrete package in your script:

```ruby
Niman::Recipe.configure do |config|
  config.package do |package|
    package.name = "vim"
    package.version = "7.4"
  end
end
```

#### Custom packages

Custom packages live in `packages/`. Every package gets its own file.

Package description:
```ruby
#packages/ruby.rb
require 'niman'
class RubyPackage < Niman::Package
  package :ubuntu, "ruby1.9.1"
  package :centos, "ruby1.9.1"
end
```
In your `Nimanfile`:
```ruby
Niman::Recipe.configure do |config|
  config.package "packages/ruby"
end
```

A custom package can have one or more configuration files inside of it:

```ruby
#packages/nginx
class NginxPackage < Niman::Package
  package :ubuntu, 'nginx'
  
  configuration '/etc/nginx/nginx.conf' do |config|
    #general nginx configuration goes here
    config.content = '...'
  end
  
  configuration '/etc/nginx/sites-available/example.com' do |config|
    config.content = '...'
  end
end
```

### Apply `Nimanfile`

To apply a `Nimanfile` run:

```bash
$ niman apply
```

### Use it as a Vagrant plugin

At first, install it as Vagrant plugin:
```bash
$ vagrant plugin install niman
```

Then, in `Vagrantfile`, add this line:

```ruby
config.vm.provision "niman"
```
Save the file and after this you can `vagrant provision`.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/niman/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
