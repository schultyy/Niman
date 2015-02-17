require 'spec_helper'
require 'niman/library/custom_package'

describe Niman::Library::CustomPackage do
  subject(:package) { Niman::Library::CustomPackage }
  describe '.package_name' do
    it 'sets a package name for a certain OS' do
      package.package_name(:centos, 'ngnix')
      expect(package.package_names.length).to eq 1
    end
  end

  describe ".file" do
    let(:path) { '/etc/nginx/nginx.conf' }
    it 'accepts a filename' do
      package.file(path)
      expect(package.files.first.path).to eq path
    end

    it 'accepts a block and passes a file object' do
      expect { |b| package.file(path, &b) }.to yield_with_args(Niman::Library::File)
    end
  end

  describe '.valid?' do
    before do
      package.instance_variable_set(:@package_names, {})
    end

    it 'is not valid when package_names not set' do
      expect(package.valid?).to be false
    end

    it 'is not valid when package name is empty' do
      package.package_name :ubuntu, ''
      expect(package.valid?).to be false
    end

    it 'is valid when at least one package name is set' do
      package.package_name :ubuntu, 'nginx'
      expect(package.valid?).to be true
    end
  end

  describe '.errors' do
    it 'returns empty array when package is valid' do
      package.package_name :centos, 'foo'
      expect(package.errors).to eq []
    end

    it 'returns error when package is not valid' do
      package.package_name :centos, ''
      expect(package.errors).to_not be nil
    end
  end
end
