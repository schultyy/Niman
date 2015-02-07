module Niman
  module Library
    class Package
      include Virtus.model

      attribute :name, String
      attribute :version, String
    end
  end
end
