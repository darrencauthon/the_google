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
               d['start'] = DateTime.parse(event.start.to_s).to_s if event.start
               d['end']   = DateTime.parse(event.end.to_s).to_s if event.end
             end
      perspective.client.execute(api_method: perspective.calendar_service.events.insert,
                                 headers:    { 'Content-Type' => 'application/json' },
                                 body:       JSON.dump(data),
                                 parameters: { 'calendarId' => id } )
    end

    def events_between min, max
      min = DateTime.parse(min.to_s).to_s
      max = DateTime.parse(max.to_s).to_s
      results = perspective.client.execute(api_method: perspective.calendar_service.events.list, 
                                           parameters: { 'calendarId' => id, 'timeMin' => min, 'timeMax' => max })
      results.data.items.map do |x|
        TheGoogle::Event.new.tap do |e|
          e.name = x.summary
          if x.start.date_time || x.start.date
            e.start = x.start.date_time || Time.parse(x.start.date)
          end
          if x.end.date_time || x.end.date
            e.end = x.end.date_time || Time.parse(x.end.date)
          end
        end
      end.select { |x| x.start && x.end }
    end

  end

end
