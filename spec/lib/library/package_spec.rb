require 'spec_helper'
require 'niman/library/package'

describe Niman::Library::Package do
  subject(:package) { Niman::Library::Package.new }
  [:name, :version].each do |attribute|
    it "responds to #{attribute}" do
      expect(package.respond_to?(attribute)).to be true
    end
  end
end
