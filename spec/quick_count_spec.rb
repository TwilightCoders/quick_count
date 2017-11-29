require "spec_helper"

describe QuickCount do
  it "is present in models" do
    expect(Post).to respond_to(:quick_count)
    expect(Post.all).to respond_to(:count_estimate)
  end

  it "returns the correct count" do
    expect(Post.quick_count).to be(0)
    expect(Post.all.count_estimate).to be > 0
  end

  it "root has the right value" do
    expect(QuickCount.root).not_to be_nil
  end

end
