require 'niman/exceptions'

module Niman
  class Provisioner
    attr_reader :instructions

    def initialize(installer, filehandler, instructions)
      @installer    = installer
      @filehandler  = filehandler
      @instructions = Array(instructions)
    end

    def valid?
      @instructions.all?(&:valid?)
    end

    def errors
      @instructions.map(&:errors).flatten.join("\n")
    end

    def run
      raise Niman::ConfigError, self.errors unless self.valid?
      @instructions.each do |instruction|
        yield(instruction) if block_given?
        if instruction.respond_to?(:run)
          @filehandler.run(instruction)
        else
          @installer.install(instruction)
        end
      end
    end
  end
end
