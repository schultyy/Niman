require 'spec_helper'
require 'niman/library/file'

describe Niman::Library::File do
  subject(:file) { Niman::Library::File.new }
  [:path, :content].each do |attribute|
    it "responds to #{attribute}" do
      expect(file.respond_to?(attribute)).to be true
    end
  end

  describe '#initialize' do
    it 'accepts path' do
      f = Niman::Library::File.new(path: '/foo/bar')
      expect(f.path).to eq '/foo/bar'
    end

    it 'accepts content' do
      f = Niman::Library::File.new(content: 'Alice likes Bob')
      expect(f.content).to eq 'Alice likes Bob'
    end
  end
end
