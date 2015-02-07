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
end
