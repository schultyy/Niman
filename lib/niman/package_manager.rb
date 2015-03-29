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

    def installed?(package_name)
      return false if search_command.nil?
      result = shell.exec("#{search_command} #{package_name}")
      return false if result.nil?
      result.scan(/Status: install ok installed/).length > 0
    end
  end
end
