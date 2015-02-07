require 'virtus'

module Niman
  class Installer
    include Virtus.model

    attribute :managers, Hash[Symbol=>String]
  end
end
