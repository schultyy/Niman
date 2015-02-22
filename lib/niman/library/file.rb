require 'virtus'

module Niman
  module Library
    class File
      include Virtus.model

      attribute :path, String, default: ''
      attribute :content, String, default: ''

      def valid?
        !self.path.nil? && !self.path.empty?
      end

      def errors
        ['file path must not be nil and empty']
      end

      def description
        "File #{path}"
      end
    end
  end
end
