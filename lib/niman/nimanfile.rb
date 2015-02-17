require 'niman/library/file'

module Niman
  class Nimanfile
    attr_reader :instructions

    def initialize
      @instructions = []
    end

    def file(path)
      f = Niman::Library::File.new(path: path)
      yield(f)
      @instructions.push(f)
    end

    def package(path = nil)
      package = Niman::Library::Package.new
      package.path = path unless path.nil?
      yield(package) if block_given?
      @instructions.push(package)
    end
  end
end
