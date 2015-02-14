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
          @files << Niman::Library::File.new(path: path)
        end
      end
    end
  end
end

