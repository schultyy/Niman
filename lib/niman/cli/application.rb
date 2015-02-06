require 'thor'
require 'niman/recipe'

module Niman
  module CLI
    class Application < Thor
      desc "apply", "Applies a Nimanfile"
      def apply
        Niman::Recipe.from_file
      rescue LoadError => e
        error e.message
      end
    end
  end
end
