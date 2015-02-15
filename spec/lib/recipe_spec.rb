require 'spec_helper'
require 'niman/recipe'

describe Niman::Recipe do
  describe '.configure' do
    before do
      Niman::Recipe.configure do |config|
        config.file '/home/bob/hello.txt' do |file|
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
        config.file '/home/bob/hello.txt' do |file|
          file.content = 'hello from alice'
        end
      end
      Niman::Recipe.reset
    end

    it 'erases current configuration' do
      expect(Niman::Recipe.configuration.instructions.length).to eq 0
    end
  end

  describe '.from_file' do
    before do
      FakeFS.deactivate!
      content = <<-EOS
      Niman::Recipe.configure do |config|
        config.file '/home/bob/hello.txt' do |file|
          file.content = 'hello from alice'
        end
      end
      EOS
      File.open(Niman::Recipe::DEFAULT_FILENAME, "w") {|handle| handle.write(content) }
      File.open('CustomNimanfile', "w") {|handle| handle.write(content) }
    end
    after do
      File.delete(Niman::Recipe::DEFAULT_FILENAME)
      File.delete('CustomNimanfile')
      FakeFS.activate!
      Niman::Recipe.reset
    end

    it 'loads "Nimanfile"' do
      Niman::Recipe.from_file(Niman::Recipe::DEFAULT_FILENAME)
      expect(Niman::Recipe.configuration.instructions.length).to eq 1
    end

    it 'loads Nimanfile from custom path' do
      Niman::Recipe.from_file('CustomNimanfile')
      expect(Niman::Recipe.configuration.instructions.length).to eq 1
    end
  end
end
