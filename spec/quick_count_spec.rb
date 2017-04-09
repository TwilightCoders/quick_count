require "spec_helper"
require 'pry'

describe QuickCount do
  it "is present in models" do
    expect(Post).to respond_to(:quick_count)
    expect(Post.all).to respond_to(:count_estimate)
  end

  it "returns the correct count" do
    expect(Post.quick_count).to be(0)
    expect(Post.all.count_estimate).to be > 0
  end

end
