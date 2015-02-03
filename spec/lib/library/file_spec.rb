require 'spec_helper'
require 'niman/library/file'

describe Niman::Library::File do
  subject(:file) { Niman::Library::File.new }
  [:path, :content].each do |attribute|
    it "responds to #{attribute}" do
      expect(file.respond_to?(attribute)).to be true
    end
  end
end
