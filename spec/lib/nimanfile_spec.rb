require 'spec_helper'
require 'niman/nimanfile'
require 'niman/library/file'

describe Niman::Nimanfile do
  subject(:niman_file) { Niman::Nimanfile.new }

  it 'has no instructions' do
    expect(niman_file.instructions.length).to eq 0
  end

  [:file, :package].each do |attribute|
    it "has #{attribute} method" do
      expect(niman_file.respond_to?(attribute)).to be true
    end
  end

  describe '#file' do
    it 'calls block with config object' do
      expect { |b| niman_file.file('/home/foo.txt', &b) }.to yield_with_args(Niman::Library::File)
    end

    it 'sets path' do
      niman_file.file('/home/foo.txt') {}
      expect(niman_file.instructions.first.path).to eq '/home/foo.txt'
    end
  end

  specify 'package calls block with config object' do
    expect { |b| niman_file.package(&b) }.to yield_with_args(Niman::Library::Package)
  end

  describe '#instructions' do
    before do
      niman_file.file('') {}
    end

    specify 'increases when #file is being called' do
      expect(niman_file.instructions.length).to eq 1
    end

    specify 'contains file object' do
      expect(niman_file.instructions.first).to be_kind_of(Niman::Library::File)
    end
  end

end
