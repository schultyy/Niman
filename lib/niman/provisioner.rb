require 'niman/exceptions'

module Niman
  class Provisioner
    attr_reader :instructions

    def initialize(instructions)
      @instructions = Array(instructions)
    end

    def valid?
      @instructions.all?(&:valid?)
    end

    def run
      raise Niman::ConfigError unless self.valid?
      @instructions.each(&:run)
    end
  end
end
