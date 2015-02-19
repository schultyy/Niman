module Niman
  module Library
    class Command
      include Virtus.model

      attribute :command, String

      def valid?
        true
      end
    end
  end
end
