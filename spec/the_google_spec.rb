require_relative 'spec_helper'

describe TheGoogle do

  describe "perspective_of" do

    let(:key)   { random_string }
    let(:the_value) { random_string }
    let(:input) { { key => the_value } }

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
      result.config[key].must_equal the_value
    end

    it "should also merge in the configuration values" do
      result.config[config_key].must_equal config_value
    end

  end

  describe "config" do

    it "should default to an empty array" do
      TheGoogle.instance_eval { @config = nil }
      TheGoogle.config.count.must_equal 0
      TheGoogle.config.is_a?(Hash).must_equal true
    end

    it "should return whatever is set in config" do
      config = Object.new
      TheGoogle.set_config config
      TheGoogle.config.must_be_same_as config
    end

  end

end
