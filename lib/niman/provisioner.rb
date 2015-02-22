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
        if is_file(instruction)
          @filehandler.run(instruction)
        elsif instruction.respond_to?(:command)
          command(instruction)
        else
          @installer.install(instruction)
        end

        if instruction.respond_to?(:files)
          custom_package_files(instruction)
        end
        if instruction.respond_to?(:commands)
          custom_package_exec(instruction)
        end
      end
    end

    private

    def is_file(instruction)
      instruction.respond_to?(:path) && 
        instruction.respond_to?(:content)
    end

    def custom_package_exec(instruction)
      return if instruction.commands.nil?
      instruction.commands.each { |cmd| command(cmd) }
    end

    def custom_package_files(instruction)
      instruction.files.each do |file|
        @filehandler.run(file)
      end
    end

    def command(instruction)
      mode = case instruction.use_sudo
             when :sudo
               true
             when :no_sudo
               false
             end
      @shell.exec(instruction.command, mode)
    end
  end
end
