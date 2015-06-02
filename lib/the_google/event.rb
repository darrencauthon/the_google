module TheGoogle
  class Event
    attr_accessor :name
    attr_accessor :start, :end

    def valid?
      self.start && self.end
    end
  end
end
