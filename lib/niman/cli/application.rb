require 'thor'
require 'niman/recipe'
require 'niman/provisioner'
require "niman/shell"
require "niman/installer"
require "niman/exceptions"
require "niman/filehandler"
require "niman/package_resolver"
require "niman/package_manager"

module Niman
  module CLI
    class Application < Thor
      attr_accessor :client_shell, :silent

      def initialize(*args)
        super
        @client_shell= Niman::Shell.new
        @silent = false
      end

      desc "apply [NIMANFILE]", "Applies a Nimanfile"
      def apply(file='Nimanfile')
        begin
          Niman::Recipe.reset
          Niman::Recipe.from_file(file)
          config = Niman::Recipe.configuration
          installer = Niman::Installer.new(shell: client_shell,
                                           package_manager: load_package_manager)
          resolver    = Niman::PackageResolver.new(config.instructions)
          filehandler = Niman::FileHandler.new(client_shell)
          provisioner = Niman::Provisioner.new(installer, filehandler, @client_shell, resolver.resolve)
          this = self
          provisioner.run do |instruction|
            this.say "Executing task #{instruction.description}" unless @silent
          end
        rescue LoadError => e
          client_shell.print(e.message, :error)
        rescue Niman::ConfigError => cfg_error
          client_shell.print(cfg_error.message, :error)
        end
      end

      desc "setup [FILENAME]", "Generates an empty Nimanfile"
      def setup(filename=Niman::Recipe::DEFAULT_FILENAME)
        content = <<-EOS
# -*- mode: ruby -*-
# vi: set ft=ruby :
Niman::Recipe.configure do |config|
end
        EOS
        File.open(filename, "w") { |handle| handle.write(content) }
        say "Created new file #{filename}"
      end
      private
      def load_package_manager
        managers = {}
        managers[:debian] = Niman::PackageManager.new(
         :os => :debian,
         :install_command => 'apt-get -y install',
         :search_command => 'dpkg -s',
         :shell => @client_shell)
        managers[:redhat] = Niman::PackageManager.new(
          :os => :redhat,
          :install_command => 'yum -y install',
          :search_command => '',
          :shell => @client_shell)
        managers.fetch(@client_shell.os.to_sym) { raise Niman::InstallError, @client_shell.os }
      end
    end
  end
end
