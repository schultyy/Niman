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

  describe "commands" do
    def write_file(body)
      nimanfile = <<-EOS
        Niman::Recipe.configure do |config|
          #{body}
        end
      EOS
      File.open(Niman::Recipe::DEFAULT_FILENAME, "w") {|h| h.write(nimanfile)}
    end

    context 'without sudo' do
      it 'is passed to shell' do
        allow(shell).to receive(:exec)
        write_file("config.exec 'touch hello.txt'")
        application.apply
        expect(shell).to have_received(:exec).with("touch hello.txt", false)
      end

      it 'does not execute when argument is empty' do
        write_file("config.exec ''")
        allow(shell).to receive(:print).with(any_args)
        application.apply
        expect(shell).to have_received(:print).with(any_args)
      end
    end
    context 'with sudo' do
      it 'is passed to shell' do
        allow(shell).to receive(:exec)
        write_file("config.exec :sudo, 'apt-get update'")
        application.apply
        expect(shell).to have_received(:exec).with('apt-get update', true)
      end
    end
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

    specify 'with with content' do
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
    it 'installs git package' do
      expect(shell).to have_received(:exec).with("apt-get -y install git", true)
    end
  end

  describe "custom package" do
    context 'is nonexistant' do
      before do
        nimanfile = <<-EOS
            #-*- mode: ruby -*-
            # vi: set ft=ruby :
            require 'niman'
            Niman::Recipe.configure do |config|
              config.package "packages/nginx" 
            end
        EOS
        File.open(Niman::Recipe::DEFAULT_FILENAME, "w") {|h| h.write(nimanfile)}
        allow(shell).to receive(:print)
        application.apply
      end

      it 'prints out validation error' do
        expect(shell).to have_received(:print)
      end
    end
    context 'is existant' do
      before do
        nginx_package = <<-EOS
       require 'niman'

       class Nginx < Niman::Library::CustomPackage
         package_name :debian, 'nginx'

         file '/etc/nginx/nginx.conf' do |config|
             config.content = 'foo bar'
         end
       end
        EOS

        nimanfile = <<-EOS
      #-*- mode: ruby -*-
      # vi: set ft=ruby :
      require 'niman'
      Niman::Recipe.configure do |config|
        config.package "packages/nginx" 
      end
        EOS
        FileUtils.mkdir("packages")
        File.open("packages/nginx.rb", "w") {|h| h.write(nginx_package)}
        File.open(Niman::Recipe::DEFAULT_FILENAME, "w") {|h| h.write(nimanfile)}
        allow(shell).to receive(:create_file)
        allow(shell).to receive(:exec)
        application.apply
      end
      after do
        FileUtils.rm_r("packages")
      end

      it 'installs nginx package' do
        expect(shell).to have_received(:exec).with("apt-get -y install nginx", true)
      end

      it 'writes /etc/nginx/nginx.conf' do
        expect(shell).to have_received(:create_file).with('/etc/nginx/nginx.conf', 'foo bar')
      end
    end
  end
end
