module TheGoogle

  class Calendar

    attr_accessor :name, :access_role, :id
    attr_accessor :perspective

    def self.build_all_from api_output, perspective
      api_output.data.items.map do |item|
        new.tap do |c|
          c.name        = item.summary
          c.access_role = item.access_role
          c.id          = item.id
          c.perspective = perspective
        end
      end
    end

    def add event
      data = { 'summary' => event.name }.tap do |d|
               d['start'] = { 'dateTime' => DateTime.parse(event.start.to_s).to_s } if event.start
               d['end']   = { 'dateTime' => DateTime.parse(event.end.to_s).to_s } if event.end
             end
      perspective.client.execute(api_method: perspective.calendar_service.events.insert,
                                 headers:    { 'Content-Type' => 'application/json' },
                                 body:       JSON.dump(data),
                                 parameters: { 'calendarId' => id } )
    end

    def events_between min, max
      event_records_between(min, max)
        .map    { |r| build_the_google_event_from r }
        .select { |e| e.valid? }
        .map    { |e| e.recurrence ? TheGoogle::Event.apply_recurrence(e, [min, max]) : e }
        .flatten
    end

    private

    def event_records_between min, max
      min = DateTime.parse(min.to_s).to_s
      max = DateTime.parse(max.to_s).to_s
      perspective
        .client
        .execute(api_method: perspective.calendar_service.events.list, 
                 parameters: { 'calendarId' => id, 'timeMin' => min, 'timeMax' => max })
        .data.items
    end

    def build_the_google_event_from record
      TheGoogle::Event.new.tap do |e|
        e.name = record.summary
        e.recurrence = record.recurrence if record.respond_to?(:recurrence) && record.recurrence
        if record.start && (record.start.date_time || record.start.date)
          e.start = record.start.date_time || Time.parse(record.start.date)
        end
        if record.end && (record.end.date_time || record.end.date)
          e.end = record.end.date_time || Time.parse(record.end.date)
        end
      end
    end

  end

end
