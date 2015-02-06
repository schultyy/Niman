require 'niman/nimanfile'

module Niman
  class Recipe
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
  end
end
