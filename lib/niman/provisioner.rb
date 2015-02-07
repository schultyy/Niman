module Niman
  class Provisioner
    attr_reader :instructions

    def initialize(instructions)
      @instructions = Array(instructions)
    end
  end
end
