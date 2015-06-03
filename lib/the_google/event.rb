module TheGoogle
  class Event
    attr_accessor :name
    attr_accessor :start, :end
    attr_accessor :recurrence

    def valid?
      self.start && self.end
    end
  end
end
