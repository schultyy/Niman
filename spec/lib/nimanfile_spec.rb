require 'spec_helper'
require 'niman/nimanfile'

describe Niman::Nimanfile do
  subject(:niman_file) { Niman::Nimanfile.new }

  it 'has file method' do
    expect(niman_file.respond_to?(:file)).to be true
  end
end
