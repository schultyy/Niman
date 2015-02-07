require 'spec_helper'
require 'niman/provisioner'

describe Niman::Provisioner do
  let(:file) { Niman::Library::File.new(path: '~/hello.txt', content: 'ohai') }
  describe "#initialize" do
    it 'accepts a list of instructions' do
      provisioner = Niman::Provisioner.new([file])
      expect(provisioner.instructions).to eq [file]
    end

    it 'accepts a single instruction' do
      provisioner = Niman::Provisioner.new(file)
      expect(provisioner.instructions).to eq [file]
    end
  end
end
