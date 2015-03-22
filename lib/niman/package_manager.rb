require 'virtus'

module Niman
  class PackageManager
    include Virtus.model
    attribute :os, String, default: ''
    attribute :install_command, String, default: ''
  end
end
