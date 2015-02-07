module Niman
  module Library
    class Package
      include Virtus.model

      attribute :name, String, default: ""
      attribute :version, String, default: ""
    end
  end
end
