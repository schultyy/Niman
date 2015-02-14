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
end
