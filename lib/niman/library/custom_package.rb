module Niman
  module Library
    class CustomPackage
      class << self
        attr_reader :package_names, :files

        def package_name(os, name)
          @package_names ||= {}
          @package_names[os.to_sym] = name
        end

        def file(path)
          @files ||= []
          file = Niman::Library::File.new(path: path)
          yield file if block_given?
          @files << file
        end
      end
    end
  end
end

