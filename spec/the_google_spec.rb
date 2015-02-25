require_relative 'spec_helper'

describe TheGoogle do

  describe "perspective_of" do

    let(:key)   { random_string }
    let(:value) { random_string }
    let(:input) { { key => value } }

    let(:config)       { { config_key => config_value } }
    let(:config_key)   { random_string }
    let(:config_value) { random_string }

    let(:result) { TheGoogle.perspective_of input }

    before do
      TheGoogle.stubs(:config).returns config
    end

    it "should return a perspective object" do
      result.is_a?(TheGoogle::Perspective).must_equal true
    end

    it "should set the config variables based on what is passed in" do
      result.config[key].must_equal value
    end

    it "should also merge in the configuration values" do
      result.config[config_key].must_equal config_value
    end

  end

end
