require 'niman/exceptions'

module Niman
  class Provisioner
    attr_reader :instructions

    def initialize(installer, instructions)
      @installer    = installer
      @instructions = Array(instructions)
    end

    def valid?
      @instructions.all?(&:valid?)
    end

    def run
      raise Niman::ConfigError unless self.valid?
      @instructions.each do |instruction|
        yield(instruction) if block_given?
        if instruction.respond_to?(:run)
          instruction.run
        else
          @installer.install(instruction)
        end
      end
    end
  end
end
