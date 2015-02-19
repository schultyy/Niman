require 'niman/library/file'
require 'niman/library/command'

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

    def exec(command)
      @instructions.push(Niman::Library::Command.new(command: command))
    end
  end
end
