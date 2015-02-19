require 'niman/exceptions'

module Niman
  class Provisioner
    attr_reader :instructions

    def initialize(installer, filehandler, shell, instructions)
      @installer    = installer
      @filehandler  = filehandler
      @shell        = shell
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
        if instruction.respond_to?(:files)
          instruction.files.each do |file|
            @filehandler.run(file)
          end
        end
        if instruction.respond_to?(:run)
          @filehandler.run(instruction)
        elsif instruction.respond_to?(:command)
          puts instruction.use_sudo
          mode = case instruction.use_sudo
                 when :sudo
                   true
                 when :no_sudo
                   false
                 end
          @shell.exec(instruction.command, mode)
        else
          @installer.install(instruction)
        end
      end
    end
  end
end
