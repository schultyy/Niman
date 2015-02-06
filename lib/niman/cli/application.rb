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

      desc "setup", "Generates an empty Nimanfile"
      def setup
        content = <<-EOS
  Niman::Recipe.configure do |config|
  end
        EOS
        File.open(Niman::Recipe::DEFAULT_FILENAME, "w") { |handle| handle.write(content) }
        say "Created new file #{Niman::Recipe::DEFAULT_FILENAME}"
      end
    end
  end
end
