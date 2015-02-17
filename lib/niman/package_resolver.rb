module Niman
  class PackageResolver

    def initialize(instructions)
      @instructions = instructions
    end

    def resolve
      Array(@instructions).map do |instruction|
        if is_file?(instruction) && !instruction.path.empty?
          self.by_name(self.load(instruction.path))
        else
          instruction
        end
      end
    end

    def load(filename)
      basename = File.basename(filename ,File.extname(filename))
      require File.expand_path(File.join('packages/', basename))
      titleize(basename)
    end

    def by_name(name)
      Kernel.const_get(name)
    end

    private

    def is_file?(obj)
      obj.respond_to?(:path) && obj.respond_to?(:name)
    end

    def titleize(filename)
      filename.split('_').map(&:capitalize).join('')
    end
  end
end
