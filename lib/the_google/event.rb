module TheGoogle
  class Event
    attr_accessor :name
    attr_accessor :start, :end
    attr_accessor :recurrence

    def valid?
      self.start && self.end
    end

    def self.apply_recurrence event, timeframe
      return [event] if event.recurrence.nil? || event.recurrence.empty?
      dates_for(event).map { |d| build_a_new_event_for event, d, timeframe }
    end

    class << self

      private

      def dates_for event
        lookup_recurring_dates date: event.start, recur: event.recurrence[0]
      end

      def build_a_new_event_for event, date, timeframe
        event.dup.tap do |new_event|
          new_event.start = date
          new_event.end   = date + (event.end - event.start)
        end
      end

    end

  end
end
