require 'spec_helper'
require 'niman/library/file'
require 'fakefs'

describe Niman::Library::File do
  subject(:file) { Niman::Library::File.new }
  [:path, :content].each do |attribute|
    it "responds to #{attribute}" do
      expect(file.respond_to?(attribute)).to be true
    end
  end

  describe '#initialize' do
    it 'accepts path' do
      f = Niman::Library::File.new(path: '/foo/bar')
      expect(f.path).to eq '/foo/bar'
    end

    it 'accepts content' do
      f = Niman::Library::File.new(content: 'Alice likes Bob')
      expect(f.content).to eq 'Alice likes Bob'
    end
  end

  describe '#content' do
    it 'defaults to empty string' do
      expect(file.content).to eq ''
    end
  end

  describe '#path' do
    it 'defaults to empty string' do
      expect(file.path).to eq ''
    end
  end

  describe "#valid?" do
    specify 'if it has path' do
      file.path = '/foo/bar'
      expect(file.valid?).to be true
    end

    it 'is not valid when path is empty' do
      expect(file.valid?).to be false
    end

    it 'is not valid when path is nil' do
      file.path = nil 
      expect(file.valid?).to be false
    end
  end

  describe "#run" do
    let(:path) { 'hello.txt' }
    let(:content) { 'FooBar' }
    subject(:file) { Niman::Library::File.new(path: path, content: content) }
    before do
      file.run
    end

    it 'creates a file at path' do
      expect(File.exists?(path)).to be true
    end

    it 'file has expected content' do
      expect(File.read(path)).to eq content
    end
  end

  describe "#description" do
    let(:path) { 'hello.txt' }
    subject(:file) { Niman::Library::File.new(path: path) }
    it 'contains path' do
      expect(file.description).to eq "File #{path}"
    end
  end
end
