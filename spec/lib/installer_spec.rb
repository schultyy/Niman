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

    it 'accepts a shell' do
      shell = double()
      installer = Niman::Installer.new(shell: shell)
      expect(installer.shell).to eq shell
    end
  end

  describe "#managers" do
    it 'defaults to empty hash' do
      installer = Niman::Installer.new
      expect(installer.managers).to eq Hash.new
    end
  end

  describe "#install" do
    let(:shell) { double() }
    subject(:installer) { Niman::Installer.new(managers: {
        debian: 'apt-get',
        redhat: 'yum'
    }, shell: shell)}
    let(:vim_package) { Niman::Library::Package.new(name: 'vim') }
    let(:ssh_package) { Niman::Library::Package.new(name: 'ssh') }
    let(:packages) { [vim_package, ssh_package] }

    context 'with valid operating system' do
      before do
        allow(shell).to receive(:os).and_return(:debian)
        allow(shell).to receive(:exec)
        installer.install(packages)
      end

      ['vim', 'ssh'].each do |package|
        it "calls shell for #{package}" do
          expect(shell).to have_received(:exec).with("apt-get install #{package}", true)
        end
      end
    end

    it 'raises for unknown operating system' do
      allow(shell).to receive(:os).and_return(:freebsd)
      expect { installer.install(packages) }.to raise_error(Niman::InstallError)
    end
  end
end
