require 'spec_helper'
require 'niman/filehandler'

describe Niman::FileHandler do
  let(:file1) { Niman::Library::File.new(path: '~/foo.txt', content: 'bar') }
  let(:file2) { Niman::Library::File.new(path: '~/bar.txt', content: 'baz') }
  let(:files) { [file1, file2] }
  subject(:filehandler) { Niman::FileHandler.new(files) }
  describe "#initialize" do
    it 'accepts a list of files' do
      expect(filehandler.files).to eq files
    end
  end
end
