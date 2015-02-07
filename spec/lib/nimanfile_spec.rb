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

  specify 'file calls block with config object' do
    expect { |b| niman_file.file(&b) }.to yield_with_args(Niman::Library::File)
  end

  describe '#instructions' do
    before do
      niman_file.file {}
    end
    specify 'increases when #file is being called' do
      expect(niman_file.instructions.length).to eq 1
    end

    specify 'contains file object' do
      expect(niman_file.instructions.first).to be_kind_of(Niman::Library::File)
    end
  end

end
