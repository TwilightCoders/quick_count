require "spec_helper"

describe CountEstimate do

  it "uses the base_class of the subject model for connection handling" do
    expect(Post.base_class).to receive(:connection).at_least(:once).and_call_original

    Post.all.count_estimate
  end

end
