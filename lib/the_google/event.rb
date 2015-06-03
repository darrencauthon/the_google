module TheGoogle
  class Event
    attr_accessor :name
    attr_accessor :start, :end
    attr_accessor :recurrence

    def valid?
      self.start && self.end
    end

    def self.apply_recurrence event
      [event]
    end

  end
end
