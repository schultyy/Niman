module Niman
  class FileHandler
    attr_reader :shell

    def initialize(shell)
      @shell = shell
    end

    def run(files)
      files.each do |file|
        shell.create_file(file.path, file.content)
      end
    end
  end
end
