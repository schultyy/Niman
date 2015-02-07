require 'spec_helper'
require 'niman/library/package'

describe Niman::Library::Package do
  subject(:package) { Niman::Library::Package.new }
  [:name, :version].each do |attribute|
    it "responds to #{attribute}" do
      expect(package.respond_to?(attribute)).to be true
    end
  end

  describe "#name" do
    it "defaults to empty string" do
      expect(package.name).to eq ""
    end
  end

  describe "#version" do
    it "defaults to empty string" do
      expect(package.version).to eq ""
    end
  end
end
