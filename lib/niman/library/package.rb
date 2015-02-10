module Niman
  module Library
    class Package
      include Virtus.model

      attribute :name, String, default: ""
      attribute :version, String, default: ""

      def description
        name
      end

      def valid?
        !name.empty?
      end

      def errors
        'package name must not be empty'
      end
    end
  end
end
