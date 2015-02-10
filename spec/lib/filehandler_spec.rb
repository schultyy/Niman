require 'spec_helper'
require 'niman/filehandler'
require 'niman/shell'

describe Niman::FileHandler do
  let(:file1) { Niman::Library::File.new(path: '~/foo.txt', content: 'bar') }
  let(:file2) { Niman::Library::File.new(path: '~/bar.txt', content: 'baz') }
  let(:files) { [file1, file2] }
  let(:shell) { double(Niman::Shell) }
  subject(:filehandler) { Niman::FileHandler.new(shell) }

  describe "#initialize" do
    it 'accepts a shell' do
      expect(filehandler.shell).to eq shell
    end
  end

  describe '#run' do
    before do
      allow(shell).to receive(:exec)
      filehandler.run(files)
    end

    it 'writes files' do
      expect(shell).to have_received(:exec).twice
    end
  end
end
