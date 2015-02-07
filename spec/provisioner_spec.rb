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

  describe "#valid?" do
    let(:instructions) { }
    subject(:provisioner) { Niman::Provisioner.new(instructions) }
    context 'with valid instructions' do
      let(:instructions) { [file] }
      it 'returns true' do
        expect(provisioner.valid?).to be true
      end
    end

    context 'with invalid instructions' do
      let(:invalid_file) { Niman::Library::File.new() }
      let(:instructions) { [file, invalid_file] }
      it 'returns false' do
        expect(provisioner.valid?).to be false
      end
    end
  end
end
