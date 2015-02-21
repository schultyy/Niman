module Niman
  module Library
    class Command
      include Virtus.model

      attribute :command, String
      attribute :use_sudo, Symbol, default: :no_sudo

      def valid?
        !command.empty? && [:no_sudo, :sudo].include?(use_sudo)
      end

      def errors
        "command must not be empty"
      end

      def description
        if use_sudo == :sudo
          "sudo #{command}"
        else
          command
        end
      end
    end
  end
end
