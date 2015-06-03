module TheGoogle
  class Event
    attr_accessor :name
    attr_accessor :start, :end
    attr_accessor :recurrence

    def valid?
      self.start && self.end
    end

    def self.apply_recurrence event, timeframe
      return [event] if event.recurrence.nil?
      return [event] unless event.recurrence.any?
      lookup_recurring_dates(date: event.start, recur: event.recurrence[0])
      .map { |d| event.dup.tap { |e| e.start = d; e.end = d + (event.end - event.start) } }
    end

  end
end
