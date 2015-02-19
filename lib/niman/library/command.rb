module Niman
  module Library
    class Command
      include Virtus.model

      attribute :command, String

      def valid?
        !command.empty?
      end

      def errors
        "command must not be empty"
      end
    end
  end
end
