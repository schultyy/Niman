require 'spec_helper'
require 'niman/cli/application'
require 'niman/shell'

describe Niman::CLI::Application do
  let(:shell) { double(Niman::Shell) }
  subject(:application) { Niman::CLI::Application.new }

  before do
    FakeFS.deactivate!
    application.client_shell = shell
    application.silent = true
    allow(shell).to receive(:os).and_return(:debian)
  end

  after do
    Niman::Recipe.reset
    File.delete(Niman::Recipe::DEFAULT_FILENAME)
  end

  describe "create files" do
    before do
      nimanfile = <<-EOS
      #-*- mode: ruby -*-
      # vi: set ft=ruby :
      Niman::Recipe.configure do |config|
        config.file "/etc/nginx/nginx.conf" do |file|
          file.content = '...'
        end
      end
      EOS
      File.open(Niman::Recipe::DEFAULT_FILENAME, "w") {|h| h.write(nimanfile)}
      allow(shell).to receive(:create_file)
      application.apply
    end

    it 'creates a file with content' do
      expect(shell).to have_received(:create_file).with('/etc/nginx/nginx.conf', '...')
    end
  end

  describe "install packages" do
    before do
      nimanfile = <<-EOS
      #-*- mode: ruby -*-
      # vi: set ft=ruby :
      Niman::Recipe.configure do |config|
        config.package do |package|
          package.name = 'git'
        end
      end
      EOS
      File.open(Niman::Recipe::DEFAULT_FILENAME, "w") {|h| h.write(nimanfile)}
      allow(shell).to receive(:exec)
      application.apply
    end
    after do
      File.delete(Niman::Recipe::DEFAULT_FILENAME)
    end
    it 'installs git package' do
      expect(shell).to have_received(:exec).with("apt-get -y install git", true)
    end
  end

end
