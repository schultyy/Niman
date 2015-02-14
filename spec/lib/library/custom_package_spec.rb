require 'spec_helper'
require 'niman/library/custom_package'

describe Niman::Library::CustomPackage do
  it 'responds to name' do
    expect(Niman::Library::CustomPackage.respond_to?(:name)).to be true
  end
end
