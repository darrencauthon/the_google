require_relative '../spec_helper'

describe TheGoogle::Event do

  describe "lookup recurring dates" do
    it "should be an interchangeable method" do
      Interchangeable.methods.select do |m|
        puts m.target.inspect
        m.method_name == :lookup_recurring_dates &&
        m.target      == TheGoogle::Event.singleton_class
      end.count.must_equal 1
    end

    it "should return the date, by default" do
      the_start = Object.new
      results = TheGoogle::Event.lookup_recurring_dates(date: the_start)
      results.must_equal [the_start]
    end
  end

  describe "apply recurrence" do

    let(:event) do
      TheGoogle::Event.new.tap do |e|
        e.start = now - random_integer
        e.end   = e.start + random_integer
        e.name  = random_string
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

        it "should return event objects, with the same name as the event" do
          results[0].name.must_equal event.name
          results[1].name.must_equal event.name
        end

        it "should set the start date to whatever was returned by the date service" do
          results[0].start.must_equal date1
          results[1].start.must_equal date2
        end

        it "should adjust the end date accordingly" do
          diff = event.end - event.start
          results[0].end.must_equal date1 + diff
          results[1].end.must_equal date2 + diff
        end

      end

    end

  end

end
