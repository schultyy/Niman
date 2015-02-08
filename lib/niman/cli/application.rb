require 'thor'
require 'niman/recipe'
require 'niman/provisioner'
require "niman/shell"
require "niman/installer"

module Niman
  module CLI
    class Application < Thor
      attr_accessor :client_shell, :silent

      def initialize(*args)
        super
        @client_shell= Niman::Shell.new
        @silent = false
      end

      desc "apply", "Applies a Nimanfile"
      def apply
        Niman::Recipe.from_file
        config = Niman::Recipe.configuration
        installer = Niman::Installer.new(shell: client_shell, managers:{
          debian: 'apt-get -y',
          redhat: 'yum -y'
        })
        provisioner = Niman::Provisioner.new(installer, config.instructions)
        this = self
        provisioner.run do |instruction|
          this.say "Executing task #{instruction.description}" unless @quiet
        end
      rescue LoadError => e
        error e.message
      end

      desc "setup", "Generates an empty Nimanfile"
      def setup
        content = <<-EOS
# -*- mode: ruby -*-
# vi: set ft=ruby :
Niman::Recipe.configure do |config|
end
        EOS
        File.open(Niman::Recipe::DEFAULT_FILENAME, "w") { |handle| handle.write(content) }
        say "Created new file #{Niman::Recipe::DEFAULT_FILENAME}"
      end
    end
  end
end
