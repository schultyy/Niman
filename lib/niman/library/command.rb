module Niman
  module Library
    class Command
      include Virtus.model

      attribute :command, String
      attribute :use_sudo, Symbol, default: :no_sudo

      def valid?
        !command.empty?
      end

      def errors
        "command must not be empty"
      end
    end
  end
end
