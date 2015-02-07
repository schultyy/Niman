require 'spec_helper'
require 'niman/library/task'

describe Niman::Library::Task do
  subject(:task) { Niman::Library::Task.new }
  [:valid?, :run].each do |attribute|
    it "responds to #{attribute}" do
      expect(task.respond_to?(attribute)).to be true
    end
  end
end
