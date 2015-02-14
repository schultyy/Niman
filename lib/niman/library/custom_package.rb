module Niman
  module Library
    class CustomPackage
      class << self
        attr_reader :package_names
        def package_name(os, name)
          @package_names ||= {}
          @package_names[os.to_sym] = name
        end
      end
    end
  end
end

