require 'spec_helper'
require 'niman/nimanfile'
require 'niman/library/file'

describe Niman::Nimanfile do
  subject(:niman_file) { Niman::Nimanfile.new }

  it 'has file method' do
    expect(niman_file.respond_to?(:file)).to be true
  end

  specify 'file calls block with config object' do
    expect { |b| niman_file.file(&b) }.to yield_with_args(Niman::Library::File)
  end
end
