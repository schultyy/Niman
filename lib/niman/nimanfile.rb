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
    end
  end
end
