require 'virtus'
require 'niman/shell'

module Niman
  class PackageManager
    include Virtus.model
    attribute :shell, Niman::Shell
    attribute :install_command, String, default: ''
    attribute :search_command, String, default: ''

    def install(package_name)
      shell.exec("#{install_command} #{package_name}",true)
    end
  end
end
