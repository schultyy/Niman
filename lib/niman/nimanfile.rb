require 'niman/library/file'

module Niman
  class Nimanfile
    attr_reader :instructions

    def initialize
      @instructions = []
    end

    def file
      f = Niman::Library::File.new
      yield(f)
      @instructions.push(f)
    end

    def package
      package = Niman::Library::Package.new
      yield(package)
      @instructions.push(package)
    end
  end
end
