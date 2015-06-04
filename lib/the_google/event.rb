module TheGoogle
  class Event
    attr_accessor :name
    attr_accessor :start, :end
    attr_accessor :recurrence

    def valid?
      self.start && self.end
    end

    def self.apply_recurrence event, timeframe
      this_event_recurs?(event) ? build_the_events_for(event, timeframe)
                                : [event]
    end

    class << self

      interchangeable_describe "Since I cannot find a good Ruby parser, I have to give this task out to an external service"
      interchangeable_method(:lookup_recurring_dates) do |options|
        [options[:date]]
      end

      private

      def this_event_recurs? event
        event.recurrence && event.recurrence.any?
      end

      def build_the_events_for event, timeframe
        dates_for(event, timeframe).map { |d| build_a_new_event_for event, d }
      end

      def dates_for event, timeframe
        lookup_recurring_dates date: event.start, recur: event.recurrence[0], timeframe: timeframe
      end

      def build_a_new_event_for event, date
        event.dup.tap do |new_event|
          new_event.start = date
          new_event.end   = date + (DateTime.parse(event.end.to_s) - DateTime.parse(event.start.to_s))
        end
      end

    end

  end
end
