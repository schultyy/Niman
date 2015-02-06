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
  end
end
