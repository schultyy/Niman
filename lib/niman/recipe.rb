require 'niman/nimanfile'

module Niman
  class Recipe
    DEFAULT_FILENAME = 'Nimanfile'
    class << self
      attr_writer :configuration
    end

    def self.configure
      @configuration ||= Niman::Nimanfile.new
      yield(@configuration)
    end

    def self.configuration
      @configuration
    end

    def self.reset!
      @configuration = Niman::Nimanfile.new
    end

    def self.from_file
      path = File.join(Dir.pwd, DEFAULT_FILENAME)
      load DEFAULT_FILENAME
    end
  end
end
