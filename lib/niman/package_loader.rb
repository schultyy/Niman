module Niman
  class PackageLoader
    DEFAULT_DIRECTORY = 'packages'

    def load_from_directory
      classes = []
      Dir.glob("#{DEFAULT_DIRECTORY}/*.rb").each do |file|
        basename = File.basename(file,File.extname(file))
        require File.expand_path(File.join(DEFAULT_DIRECTORY, basename))
        classes << titleize(basename)
      end
      classes
    end

    def titleize(filename)
      filename.split('_').map(&:capitalize).join('')
    end
  end
end
