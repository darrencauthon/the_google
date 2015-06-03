require_relative '../spec_helper'

describe TheGoogle::Event do

  describe "apply recurrence" do

    let(:event) { TheGoogle::Event.new }

    let(:result) { TheGoogle::Event.apply_recurrence event }

    it "should return the event, alone in an array" do
      result.count.must_equal 1
      result[0].must_be_same_as event
    end

  end

end
