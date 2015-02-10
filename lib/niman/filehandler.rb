module Niman
  class FileHandler
    attr_reader :shell

    def initialize(shell)
      @shell = shell
    end

    def run(files)
      files.each do |file|
        shell.exec(`echo #{file.content} > #{file.path}`)
      end
    end
  end
end
