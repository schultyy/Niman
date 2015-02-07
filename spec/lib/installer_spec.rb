require 'spec_helper'
require 'niman/installer'

describe Niman::Installer do
  describe '#initialize' do
    it 'accepts a hash of package managers' do
      managers = {
        ubuntu: 'apt-get',
        centos: 'yum'
      }
      installer = Niman::Installer.new(managers: managers)
      expect(installer.managers).to eq managers
    end
  end

  describe "#managers" do
    it 'defaults to empty hash' do
      installer = Niman::Installer.new
      expect(installer.managers).to eq Hash.new
    end
  end

  describe "#install" do
    subject(:installer) { Niman::Installer.new(managers: {
        ubuntu: 'apt-get',
        centos: 'yum'
    })}
    let(:vim_package) { Niman::Library::Package.new(name: 'vim') }
    let(:ssh_package) { Niman::Library::Package.new(name: 'ssh') }
    let(:packages) { [vim_package, ssh_package] }

    it 'accepts a list of packages' do
      expect{ installer.install(packages) }.to_not raise_error
    end

    it 'accepts a single package' do
      expect{ installer.install(vim_package) }.to_not raise_error
    end
  end
end
