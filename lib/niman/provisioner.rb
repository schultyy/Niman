module Niman
  class Provisioner
    attr_reader :instructions

    def initialize(instructions)
      @instructions = instructions
    end
  end
end
