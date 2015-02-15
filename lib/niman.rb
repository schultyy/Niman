require "niman/version"
require "niman/cli/application"
require "niman/library/package"
require "niman/library/custom_package"
require "niman/package_loader"

module Niman
  if defined?(::Vagrant)
    require 'niman/vagrant/plugin'
  end
end
