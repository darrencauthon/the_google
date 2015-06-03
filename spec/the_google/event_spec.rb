require_relative '../spec_helper'

describe TheGoogle::Event do

  describe "apply recurrence" do

    let(:event) { TheGoogle::Event.new }

    let(:result) { TheGoogle::Event.apply_recurrence event }

    describe "and the item has no recurrence" do
      before { event.recurrence = nil }

      it "should return the event, alone in an array" do
        result.count.must_equal 1
        result[0].must_be_same_as event
      end
    end

    describe "and the item has an empty recurrence" do
      before { event.recurrence = '' }

      it "should return the event, alone in an array" do
        result.count.must_equal 1
        result[0].must_be_same_as event
      end
    end

    describe "and the item has a single recurrence" do

      let(:recurrence) { random_string }

      before { event.recurrence = [recurrence] }

      describe "and the recurrence expands to two different dates" do
      end

    end

  end

end
