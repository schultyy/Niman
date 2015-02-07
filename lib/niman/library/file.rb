require 'virtus'

module Niman
  module Library
    class File
      include Virtus.model

      attribute :path, String, default: ''
      attribute :content, String, default: ''
    end
  end
end
