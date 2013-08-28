require 'spec_helper'
require 'pry'

describe PortScan do
  context "with a single port as an input" do
    binding.pry
    before(:all) do
      ARGV[0] = archive.org
      ARGV[1] = 80
    end

    it "accepts a single port as an argument"
    it "accepts a port range as an argument"
    it "accepts a list of ports as an argument"
  end
end