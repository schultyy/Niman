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
end
