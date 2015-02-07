require 'spec_helper'
require 'niman/provisioner'
require 'niman/exceptions'

describe Niman::Provisioner do
  let(:file) { Niman::Library::File.new(path: '~/hello.txt', content: 'ohai') }
  let(:instructions) { [file] }
  subject(:provisioner) { Niman::Provisioner.new(instructions) }
  describe "#initialize" do
    it 'accepts a list of instructions' do
      expect(provisioner.instructions).to eq [file]
    end

    it 'accepts a single instruction' do
      provisioner = Niman::Provisioner.new(file)
      expect(provisioner.instructions).to eq [file]
    end
  end

  describe "#valid?" do
    context 'with valid instructions' do
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

  describe "#run" do
    it 'raises when instruction is invalid' do
      allow(provisioner).to receive(:valid?).and_return(false)
      expect { provisioner.run }.to raise_error(Niman::ConfigError)
    end
  end
end
