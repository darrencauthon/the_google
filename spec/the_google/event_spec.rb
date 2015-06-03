require_relative '../spec_helper'

describe TheGoogle::Event do

  describe "apply recurrence" do

    let(:event) do
      TheGoogle::Event.new.tap do |e|
        e.start = now - random_integer
      end
    end

    let(:results) { TheGoogle::Event.apply_recurrence event, timeframe }

    let(:timeframe) { nil }

    let(:now) { Time.now }

    let(:min) { now - random_integer }
    let(:max) { now + random_integer }
    before { Timecop.freeze now }

    describe "and the item has no recurrence" do
      before { event.recurrence = nil }

      it "should return the event, alone in an array" do
        results.count.must_equal 1
        results[0].must_be_same_as event
      end
    end

    describe "and the item has an empty recurrence" do
      before { event.recurrence = [] }

      it "should return the event, alone in an array" do
        results.count.must_equal 1
        results[0].must_be_same_as event
      end
    end

    describe "and the item has a single recurrence" do

      let(:recurrence) { random_string }

      let(:date1) { now + random_integer }
      let(:date2) { now + random_integer }

      before { event.recurrence = [recurrence] }

      describe "and the recurrence expands to two different dates" do
        before do
          TheGoogle::Event
            .stubs(:lookup_recurring_dates)
            .with( { date: event.start, recur: recurrence } )
            .returns [date1, date2]
        end

        it "should return two events" do
          results.count.must_equal 2
        end
      end

    end

  end

end
