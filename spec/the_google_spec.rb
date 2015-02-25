require_relative 'spec_helper'

describe TheGoogle do

  describe "perspective_of" do

    let(:key)   { random_string }
    let(:value) { random_string }
    let(:input) { { key => value } }

    let(:result) { TheGoogle.perspective_of input }

    it "should return a perspective object" do
      result.is_a?(TheGoogle::Perspective).must_equal true
    end

    it "should set the config variables based on what is passed in" do
      result.config[key].must_equal value
    end

  end

end
