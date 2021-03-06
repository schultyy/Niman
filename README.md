# Niman
[![Build Status](https://travis-ci.org/schultyy/Niman.svg?branch=master)](https://travis-ci.org/schultyy/Niman)
[![Code Climate](https://codeclimate.com/github/schultyy/Niman/badges/gpa.svg)](https://codeclimate.com/github/schultyy/Niman)

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

### Commands

Niman has support to execute arbitrary commands on the host system:

```ruby
Niman::Recipe.configure do |config|
  config.exec "touch ~/hello.txt"
end
```

Or if you need sudo privileges:

```ruby
Niman::Recipe.configure do |config|
  config.exec :sudo, "apt-get update"
end
```

### Packages

Use a concrete package in your script:

```ruby
Niman::Recipe.configure do |config|
  config.package do |package|
    package.name = "vim"
  end
end
```

#### Custom packages

Custom packages live in `packages/`. Every package gets its own file.

Package description:
```ruby
#packages/ruby.rb
require 'niman'
class RubyPackage < Niman::Library::CustomPackage
  package_name :ubuntu, "ruby1.9.1"
  package_name :centos, "ruby1.9.1"
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
class NginxPackage < Niman::Library::CustomPackage
  package_name :ubuntu, 'nginx'
  
  file '/etc/nginx/nginx.conf' do |config|
    #general nginx configuration goes here
    config.content = '...'
  end
  
  file '/etc/nginx/sites-available/example.com' do |config|
    config.content = '...'
  end
end
```

A custom package can also be used as a container for a bunch of configuration files
and shell commands without the need to specify `package_names`:

```ruby
#packages/ruby
require 'niman'
class RubyPackage < Niman::Library::CustomPackage
  exec '\\curl -sSL https://get.rvm.io | bash -s stable'
  exec 'rvm install ruby --latest'
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
