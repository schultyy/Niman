module Niman
  class Provisioner
    attr_reader :instructions

    def initialize(instructions)
      @instructions = Array(instructions)
    end

    def valid?
      @instructions.all?(&:valid?)
    end
  end
end
