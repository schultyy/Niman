require 'niman/library/file'

module Niman
  class Nimanfile
    def file
      yield(Niman::Library::File.new)
    end
  end
end
