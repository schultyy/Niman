require "niman/version"
require "niman/cli/application"
require "niman/library/package"

module Niman
  if defined?(::Vagrant)
    require 'niman/vagrant/plugin'
  end
end
