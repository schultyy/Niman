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
    search_result = <<-EOS
            dpkg-query: package '' is not installed and no information is available
            Use dpkg --info (= dpkg-deb --info) to examine archive files,
            and dpkg --contents (= dpkg-deb --contents) to list their contents.
    EOS
    allow(shell).to receive(:exec).with(/dpkg -s/).and_return(search_result)
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

      it 'does not execute when argument is empty' do
        write_file("config.exec :sudo, ''")
        allow(shell).to receive(:print).with(any_args)
        application.apply
        expect(shell).to have_received(:print).with(any_args)
      end

      it 'does not execute when sudo_mode is unknown' do
        write_file("config.exec :foo, 'apt-get update'")
        allow(shell).to receive(:print).with(any_args)
        application.apply
        expect(shell).to have_received(:print).with(any_args)
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

  describe "installing a package twice" do
    before do
      nimanfile = <<-EOS
      #-*- mode: ruby -*-
      # vi: set ft=ruby :
      Niman::Recipe.configure do |config|
        config.package { |p| p.name = 'vim' }
      end
      EOS
      File.open(Niman::Recipe::DEFAULT_FILENAME, "w") {|h| h.write(nimanfile)}
      package_result_not_installed = <<-EOS
      dpkg-query: package 'vim' is not installed and no information is available
      Use dpkg --info (= dpkg-deb --info) to examine archive files,
      and dpkg --contents (= dpkg-deb --contents) to list their contents.
      EOS
      package_result_installed = <<-EOS
      Package: vim
      Status: install ok installed
      Priority: optional
      Section: editors
      Installed-Size: 2185
      Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
      Architecture: amd64
      Version: 2:7.4.052-1ubuntu3
      Provides: editor
      Depends: vim-common (= 2:7.4.052-1ubuntu3), vim-runtime (= 2:7.4.052-1ubuntu3), libacl1 (>= 2.2.51-8), libc6 (>= 2.15), libgpm2 (>= 1.20.4), libpython2.7 (>= 2.7), libselinux1 (>= 1.32), libtinfo5
      Suggests: ctags, vim-doc, vim-scripts
      Description: Vi IMproved - enhanced vi editor
       Vim is an almost compatible version of the UNIX editor Vi.
          .
           Many new features have been added: multi level undo, syntax
        highlighting, command line history, on-line help, filename
         completion, block operations, folding, Unicode support, etc.
            .
             This package contains a version of vim compiled with a rather
          standard set of features.  This package does not provide a GUI
           version of Vim.  See the other vim-* packages if you need more
            (or less).
              Homepage: http://www.vim.org/
              Original-Maintainer: Debian Vim Maintainers <pkg-vim-maintainers@lists.alioth.debian.org>
      EOS
      allow(shell).to receive(:exec).with("apt-get -y install vim", true)
      allow(shell).to receive(:exec).with("dpkg -s vim").and_return(package_result_not_installed, package_result_installed)
      application.apply
      application.apply
    end

    it 'checks if package is installed' do
      expect(shell).to have_received(:exec).with("dpkg -s vim").twice
    end

    it 'does not lead to a second install' do
      count = 0
      expect(shell).to have_received(:exec).exactly(3).times do |arg| #.with()
        if arg == "apt-get -y install vim"
          count += 1
        end
      end
      expect(count).to eq 1
    end
  end

  describe "custom package" do
    def create_package(name, content, filename)
      nginx_package = <<-EOS
          require 'niman'

          class #{name} < Niman::Library::CustomPackage
            #{content}
          end
      EOS
      FileUtils.mkdir("packages")
      File.open(filename, "w") {|h| h.write(nginx_package)}
    end
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
            package_name :debian, 'nginx'

            file '/etc/nginx/nginx.conf' do |config|
              config.content = 'foo bar'
            end

            exec :sudo, 'ln -s /etc/nginx/sites-available/example.org /etc/nginx/sites-enabled/example.org'
            exec 'touch ~/install_notes.txt'
        EOS

        nimanfile = <<-EOS
          #-*- mode: ruby -*-
          # vi: set ft=ruby :
          require 'niman'
          Niman::Recipe.configure do |config|
            config.package "packages/nginx"
          end
        EOS
        create_package('Nginx', nginx_package, "packages/nginx.rb")
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

      it 'links /etc/nginx/sites-available/example.org' do
        expect(shell).to have_received(:exec).with('ln -s /etc/nginx/sites-available/example.org /etc/nginx/sites-enabled/example.org', true)
      end

      it 'creates install_notes.txt in home directory' do
        expect(shell).to have_received(:exec).with('touch ~/install_notes.txt', false)
      end

      it 'installs package before creating configuration' do
        expect(shell).to have_received(:exec).with("apt-get -y install nginx", true).ordered
        expect(shell).to have_received(:create_file).with('/etc/nginx/nginx.conf', 'foo bar').ordered
        expect(shell).to have_received(:exec).with('ln -s /etc/nginx/sites-available/example.org /etc/nginx/sites-enabled/example.org', true).ordered
      end
    end

    context 'without package_name' do
      before do
        custom_ruby_package = <<-EOS
          exec '\\curl -sSL https://get.rvm.io | bash -s stable'
          exec 'rvm install ruby --latest'
        EOS

        nimanfile = <<-EOS
          #-*- mode: ruby -*-
          # vi: set ft=ruby :
          require 'niman'
          Niman::Recipe.configure do |config|
            config.package "packages/ruby"
          end
        EOS

        create_package('Ruby', custom_ruby_package, 'packages/ruby.rb')
        File.open(Niman::Recipe::DEFAULT_FILENAME, "w") {|h| h.write(nimanfile)}
        allow(shell).to receive(:create_file)
        allow(shell).to receive(:exec)
        application.apply
      end
      after do
        FileUtils.rm_r("packages")
      end

      it 'does not execute package manager commands' do
        expect(shell).to_not have_received(:exec).with('apt get -y install')
      end

      it 'executes curl command' do
        expect(shell).to have_received(:exec).with('\curl -sSL https://get.rvm.io | bash -s stable', false)
      end

      it 'installs latest ruby' do
        expect(shell).to have_received(:exec).with('rvm install ruby --latest',false)
      end
    end
  end
end
