require 'thor'
require 'niman/recipe'

module Niman
  module CLI
    class Application < Thor
      desc "apply", "Applies a Nimanfile"
      def apply
        Niman::Recipe.from_file
      end
    end
  end
end
