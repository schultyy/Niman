require 'spec_helper'
require 'niman/recipe'

describe Niman::Recipe do
  describe '.configure' do
    before do
      Niman::Recipe.configure do |config|
        config.file do |file|
          file.path = '/home/bob/hello.txt'
          file.content = 'hello from alice'
        end
      end
    end

    specify 'configuration has a file call' do
      expect(Niman::Recipe.configuration.instructions.length).to eq 1
    end
  end

  describe '.reset' do
    before do
      Niman::Recipe.configure do |config|
        config.file do |file|
          file.path = '/home/bob/hello.txt'
          file.content = 'hello from alice'
        end
      end
      Niman::Recipe.reset!
    end

    it 'erases current configuration' do
      expect(Niman::Recipe.configuration.instructions.length).to eq 0
    end
  end
end
