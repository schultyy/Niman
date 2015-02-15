module Niman
  module Library
    class Package
      include Virtus.model

      attribute :name, String, default: ""
      attribute :path, String, default: ""
      attribute :version, String, default: ""

      def description
        name
      end

      def valid?
        !name.empty? || !path.empty?
      end

      def errors
        'package name must not be empty'
      end
    end
  end
end
