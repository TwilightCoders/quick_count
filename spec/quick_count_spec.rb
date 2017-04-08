require "spec_helper"
require 'pry'

describe QuickCount do
  describe "all models" do
    it "respond to :quick_count" do
      expect(Post).to respond_to(:quick_count)
    end

    it "respond to :quick_count" do
      expect(Post.quick_count).to be(0)
    end

  end

end
