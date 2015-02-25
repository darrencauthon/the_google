require_relative 'spec_helper'

describe TheGoogle do

  describe "perspective_of" do

    let(:input) { Object.new }

    it "should return a perspective object" do
      result = TheGoogle.perspective_of input
      result.is_a?(TheGoogle::Perspective).must_equal true
    end

  end

end
