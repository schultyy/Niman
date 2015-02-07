require 'thor'
require 'niman/recipe'
require 'niman/provisioner'
require "niman/shell"
require "niman/installer"

module Niman
  module CLI
    class Application < Thor
      desc "apply", "Applies a Nimanfile"
      def apply
        Niman::Recipe.from_file
        config = Niman::Recipe.configuration
        shell = Niman::Shell.new
        installer = Niman::Installer.new(shell: shell, managers:{
          debian: 'apt-get',
          redhat: 'yum -y'
        })
        provisioner = Niman::Provisioner.new(installer, config.instructions)
        provisioner.run do |instruction|
          say "Executing task #{instruction.description}"
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
