module Niman
  module Library
    class CustomPackage
      class << self
        attr_reader :package_names, :files

        def valid?
          !package_names.nil? &&
          !package_names.empty? &&
          package_names.keys.all?{|k| !package_names[k].empty?}
        end

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

        def description
          ''
        end

        def errors
          return [] if self.valid?
          package_names.keys.map do |key|
            if package_names[key].empty?
              "No package name configured for OS #{key}"
            end
          end.flatten
        end
      end
    end
  end
end

