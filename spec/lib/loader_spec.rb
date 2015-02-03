require 'spec_helper'
require 'niman/config'

describe Niman::Config do
  let(:recipe) { <<-eos
    file do |config|
       config.path = '/home/foo.txt'
       config.content = 'alice likes bob'
     end
     eos
  }
  subject(:config) { Niman::Config.new }

  it "responds to load" do
    expect(config.respond_to?(:load)).to be true
  end
end
