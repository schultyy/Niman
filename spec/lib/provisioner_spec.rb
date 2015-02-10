require 'spec_helper'
require 'niman/provisioner'
require 'niman/installer'
require 'niman/exceptions'

describe Niman::Provisioner do
  let(:file)         { Niman::Library::File.new(path: '~/hello.txt', content: 'ohai') }
  let(:vim_package)  { Niman::Library::Package.new(name: 'vim') }
  let(:instructions) { [file, vim_package] }
  let(:installer)    { double(Niman::Installer) }
  let(:filehandler)  { double(Niman::FileHandler) }
  subject(:provisioner) { Niman::Provisioner.new(installer, filehandler, instructions) }

  describe "#initialize" do
    it 'accepts a list of instructions' do
      expect(provisioner.instructions).to eq [file, vim_package]
    end

    it 'accepts a single instruction' do
      provisioner = Niman::Provisioner.new(installer, filehandler, file)
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
    context 'with invalid instructions' do
      it 'raises when instruction is invalid' do
        allow(provisioner).to receive(:valid?).and_return(false)
        expect { provisioner.run }.to raise_error(Niman::ConfigError)
      end
    end

    context 'with valid instructions' do
      before do
        allow(filehandler).to receive(:run)
        allow(installer).to receive(:install)
        provisioner.run
      end

      it 'calls file handler for files' do
        expect(filehandler).to have_received(:run).with(file)
      end

      it 'calls installer for package' do
        expect(installer).to have_received(:install).with(vim_package)
      end

      it 'calls block for every instruction' do
        expect { |b| provisioner.run(&b) }.to yield_successive_args(file, vim_package)
      end
    end
  end
end
