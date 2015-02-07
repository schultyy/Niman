require 'virtus'
require 'niman/library/task'

module Niman
  module Library
    class File < Task
      include Virtus.model

      attribute :path, String, default: ''
      attribute :content, String, default: ''

      def valid?
        !self.path.nil? && !self.path.empty?
      end
    end
  end
end
