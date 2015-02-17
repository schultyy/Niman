require "niman/version"
require "niman/cli/application"
require "niman/library/package"
require "niman/library/custom_package"

module Niman
  if defined?(::Vagrant)
    require 'niman/vagrant/plugin'
  end
end
