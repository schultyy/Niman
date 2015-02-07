require 'virtus'

module Niman
  class Installer
    include Virtus.model

    attribute :managers, Hash[Symbol=>String], default: Hash.new
  end
end
