require 'virtus'

module Niman
  module Library
    class File
      include Virtus.model

      attribute :path, String
      attribute :content, String
    end
  end
end
