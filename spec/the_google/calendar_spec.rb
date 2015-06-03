require_relative '../spec_helper'

describe TheGoogle::Calendar do

  describe "add" do

    let(:calendar_id) { Object.new }
    let(:calendar) do
      TheGoogle::Calendar.new.tap do |c| 
        c.id = calendar_id
        c.stubs(:perspective).returns perspective
      end
    end

    let(:event) { TheGoogle::Event.new }

    let(:client) { Object.new }

    let(:service) do
      Struct.new(:events).new(Struct.new(:insert).new(Object.new))
    end

    let(:perspective) do
      Struct.new(:client, :calendar_service).new client, service
    end

    describe "inserting the event" do
      it "should insert the event" do
        a = service.events.insert
        client.expects(:execute).with do |request|
          request[:api_method].must_be_same_as a
        end
        calendar.add event
      end

      it "should set the calendar id" do
        id = calendar_id
        client.expects(:execute).with do |request|
          request[:parameters]['calendarId'].must_be_same_as id
        end
        calendar.add event
      end

      it "should set a json header" do
        client.expects(:execute).with do |request|
          request[:headers].must_equal( { 'Content-Type' => 'application/json' } )
        end
        calendar.add event
      end

      it "should pass the name of the event as the summary" do
        name = random_string
        event.name = name
        client.expects(:execute).with do |request|
          JSON.parse(request[:body])['summary'].must_equal name
        end
        calendar.add event
      end

      it "should pass the start" do
        expected = random_string
        start = Struct.new(:to_s).new random_string
        DateTime.stubs(:parse).with(start.to_s).returns Struct.new(:to_s).new(expected)
        event.start = start
        client.expects(:execute).with do |request|
          JSON.parse(request[:body])['start']['dateTime'].must_equal expected
        end
        calendar.add event
      end

      it "should pass the end" do
        expected = random_string
        the_end = Struct.new(:to_s).new random_string
        DateTime.stubs(:parse).with(the_end.to_s).returns Struct.new(:to_s).new(expected)
        event.end = the_end
        client.expects(:execute).with do |request|
          JSON.parse(request[:body])['end']['dateTime'].must_equal expected
        end
        calendar.add event
      end

      #client.execute(:api_method => service.events.insert,
                     #:parameters => { 'calendarId' => calendar.id },
                     #:body       => JSON.dump(event),
                     #:headers    => { 'Content-Type' => 'application/json' } )

    end

  end

  #result.data.items.first
  #<Google::APIClient::Schema::Calendar::V3::CalendarListEntry:0x3ff53b6cc01c DATA:{"kind"=>"calendar#calendarListEntry", "etag"=>"\"1524894352006000\"", "id"=>"an@email.address", "summary"=>"the calendar name", "timeZone"=>"America/Chicago", "colorId"=>"17", "backgroundColor"=>"#9a9cff", "foregroundColor"=>"#000000", "selected"=>true, "accessRole"=>"owner", "defaultReminders"=>[{"method"=>"popup", "minutes"=>10}], "notificationSettings"=>{"notifications"=>[{"type"=>"eventCreation", "method"=>"email"}, {"type"=>"eventChange", "method"=>"email"}, {"type"=>"eventCancellation", "method"=>"email"}, {"type"=>"eventResponse", "method"=>"email"}]}, "primary"=>true}>

  describe "build all from" do

    let(:api_output)  { Struct.new(:data).new(Struct.new(:items).new(items)) }
    let(:perspective) { Object.new }

    describe "there are two calendars" do

      let(:items) do
        [
          [random_string, random_string, random_string],
          [random_string, random_string, random_string],
        ].map { |x| Struct.new(:summary, :access_role, :id).new *x }
      end

      let(:results) { TheGoogle::Calendar.build_all_from api_output, perspective }

      it "should return two calendar objects" do
        results.count.must_equal 2
        results.each { |x| x.is_a?(TheGoogle::Calendar).must_equal true }
      end

      it "should set the name as the summary" do
        results[0].name.must_equal items[0].summary
        results[1].name.must_equal items[1].summary
      end

      it "should set the access role" do
        results[0].access_role.must_equal items[0].access_role
        results[1].access_role.must_equal items[1].access_role
      end

      it "should set the id" do
        results[0].id.must_equal items[0].id
        results[1].id.must_equal items[1].id
      end

      it "should pass the perspective along to each of the calendar objects" do
        results[0].perspective.must_be_same_as perspective
        results[1].perspective.must_be_same_as perspective
      end

    end

  end

  describe "events between" do

    #client.execute(api_method: service.events.list, parameters: { 'calendarId' => 'my@email.com', 'timeMin' => (DateTime.now - 7.days).to_s, 'timeMax' => (DateTime.now - 6.days).to_s })
    #_.data.items.first
    #<Google::APIClient::Schema::Calendar::V3::Event:0x3ff53b658040 DATA:{"kind"=>"calendar#event", "etag"=>"\"3379919409854001\"", "id"=>"the_id", "status"=>"confirmed", "htmlLink"=>"https://www.google.com/calendar/event?eid=123", "created"=>"2015-02-23T19:04:19.000Z", "updated"=>"2015-02-26T14:08:24.927Z", "summary"=>"Important meeting", "location"=>"online conference room", "creator"=>{"email"=>"creator@creator.com", "displayName"=>"Mr. Creator"}, "organizer"=>{"email"=>"organizer@organizer", "displayName"=>"The organizer"}, "start"=>{"dateTime"=>"2015-02-24T13:30:00-06:00"}, "end"=>{"dateTime"=>"2015-02-24T14:30:00-06:00"}, "iCalUID"=>"12345", "sequence"=>0, "attendees"=>[{"email"=>"attendee@email.com", "displayName"=>"Mr Attendee", "responseStatus"=>"accepted"}], "hangoutLink"=>"https://plus.google.com/hangouts/_/sigh/meet?hceid=1234", "reminders"=>{"useDefault"=>true}}>
    #<Google::APIClient::Schema::Calendar::V3::Event:0x402b6e8 DATA:{"kind"=>"calendar#event", "etag"=>"\"1234123412342134\"", "id"=>"_the_id", "status"=>"confirmed", "htmlLink"=>"https://www.google.com/calendar/event?eid=789", "created"=>"2015-04-20T18:31:14.000Z", "updated"=>"2015-04-20T18:31:14.549Z", "summary"=>"10 - 7", "creator"=>{"email"=>"test@testing.edu", "displayName"=>"the person", "self"=>true}, "start"=>{"dateTime"=>"2015-04-20T08:00:00-07:00", "timeZone"=>"America/Los_Angeles"}, "end"=>{"dateTime"=>"2015-04-20T10:00:00-07:00", "timeZone"=>"America/Los_Angeles"}, "recurrence"=>["RRULE:FREQ=WEEKLY;INTERVAL=1;BYDAY=MO"], "iCalUID"=>"67890", "sequence"=>0, "reminders"=>{"useDefault"=>false}}>
    let(:calendar) do
      TheGoogle::Calendar.new.tap do |c|
        c.perspective = perspective
        c.id          = calendar_id
      end
    end

    let(:perspective) do
      Struct.new(:client, :calendar_service).new client, service
    end

    let(:calendar_id) { random_string }
    let(:client)      { Object.new    }

    let(:service) do
      Struct.new(:events).new(Struct.new(:list).new(Object.new))
    end

    describe "making a google api call" do

      let(:time_min) { Struct.new(:to_s).new(Object.new) }
      let(:time_max) { Struct.new(:to_s).new(Object.new) }

      let(:formatted_time_min) { Object.new }
      let(:formatted_time_max) { Object.new }

      let(:api_result) do
        Struct.new(:data).new(Struct.new(:items).new(items))
      end

      let(:results) { calendar.events_between(time_min, time_max) }

      before do
        DateTime.stubs(:parse).with(time_min.to_s).returns Struct.new(:to_s).new(formatted_time_min)
        DateTime.stubs(:parse).with(time_max.to_s).returns Struct.new(:to_s).new(formatted_time_max)
      end

      describe "and the google api call returns two events" do

        let(:items) do
          [
            Struct.new(:summary, :start, :end).new(random_string, Struct.new(:date_time).new(Object.new), Struct.new(:date_time).new(Object.new)),
            Struct.new(:summary, :start, :end).new(random_string, Struct.new(:date_time).new(Object.new), Struct.new(:date_time).new(Object.new)),
          ]
        end

        before do
          client.stubs(:execute)
                .with(api_method: service.events.list,
                      parameters: { 
                                    'calendarId' => calendar.id,
                                    'timeMin'    => formatted_time_min,
                                    'timeMax'    => formatted_time_max,
                                  })
                .returns api_result
        end

        it "should return two events" do
          results.count.must_equal 2
          results.each { |x| x.is_a?(TheGoogle::Event).must_equal true }
        end

        it "should return the summary of each event as the name" do
          results[0].name.must_equal items[0].summary
          results[1].name.must_equal items[1].summary
        end

        it "should return the start" do
          results[0].start.must_equal items[0].start.date_time
          results[1].start.must_equal items[1].start.date_time
        end

        it "should return the end" do
          results[0].end.must_equal items[0].end.date_time
          results[1].end.must_equal items[1].end.date_time
        end

        describe "and the events have a recurrence" do

          before do
            items[0].stubs(:recurrence).returns ["RRULE:FREQ=WEEKLY;INTERVAL=1;BYDAY=MO"]
            items[1].stubs(:recurrence).returns nil
          end

          it "should set the recurrence" do
            results[0].recurrence.must_equal items[0].recurrence
            results[1].recurrence.nil?.must_equal true
          end

          describe "and applying the recurrence returns two things" do
            before do
              TheGoogle.stubs(:apply_recurrence).with do |recurred_item|
                recurred_item.recurrence.first == "RRULE:FREQ=WEEKLY;INTERVAL=1;BYDAY=MO"
              end.returns [items[0].dup, items[0].dup]
            end
            
            it "should add one to the results" do
              results.count.must_equal 3
            end
          end

        end

      end

      describe "and the google api call returns one all-day event" do

        let(:items) do
          [
            Struct.new(:summary, :start, :end)
                  .new(random_string,
                       Struct.new(:date_time, :date).new(nil, Object.new),
                       Struct.new(:date_time, :date).new(nil, Object.new)),
          ]
        end

        let(:the_start) { Object.new }
        let(:the_end)   { Object.new }

        before do

          Time.stubs(:parse).with(items[0].start.date).returns the_start
          Time.stubs(:parse).with(items[0].end.date).returns the_end

          client.stubs(:execute)
                .with(api_method: service.events.list,
                      parameters: { 
                                    'calendarId' => calendar.id,
                                    'timeMin'    => formatted_time_min,
                                    'timeMax'    => formatted_time_max,
                                  })
                .returns api_result
        end

        it "should return the start" do
          results[0].start.must_be_same_as the_start
        end

        it "should return the end" do
          results[0].end.must_be_same_as the_end
        end

      end

      describe "and the google api call returns an event with no start date" do

        let(:items) do
          [
            Struct.new(:summary, :start, :end)
                  .new(random_string,
                       Struct.new(:date_time, :date).new(nil, Object.new),
                       Struct.new(:date_time, :date).new(nil, Object.new)),
            Struct.new(:summary, :start, :end)
                  .new(random_string,
                       Struct.new(:date_time, :date).new(nil, nil),
                       Struct.new(:date_time, :date).new(nil, Object.new)),
          ]
        end

        let(:a_date) { Object.new }

        before do
          Time.stubs(:parse).returns a_date
          client.stubs(:execute)
                .with(api_method: service.events.list,
                      parameters: { 
                                    'calendarId' => calendar.id,
                                    'timeMin'    => formatted_time_min,
                                    'timeMax'    => formatted_time_max,
                                  })
                .returns api_result
        end

        it "should return one record, excluding the record with no date" do
          results.count.must_equal 1
          results[0].name.must_equal items[0].summary
        end

      end

      describe "and the google api call returns an event with no end date" do

        let(:items) do
          [
            Struct.new(:summary, :start, :end)
                  .new(random_string,
                       Struct.new(:date_time, :date).new(nil, Object.new),
                       Struct.new(:date_time, :date).new(nil, Object.new)),
            Struct.new(:summary, :start, :end)
                  .new(random_string,
                       Struct.new(:date_time, :date).new(nil, Object.new),
                       Struct.new(:date_time, :date).new(nil, nil)),
          ]
        end

        let(:a_date) { Object.new }

        before do
          Time.stubs(:parse).returns a_date
          client.stubs(:execute)
                .with(api_method: service.events.list,
                      parameters: { 
                                    'calendarId' => calendar.id,
                                    'timeMin'    => formatted_time_min,
                                    'timeMax'    => formatted_time_max,
                                  })
                .returns api_result
        end

        it "should return one record, excluding the record with no date" do
          results.count.must_equal 1
          results[0].name.must_equal items[0].summary
        end

      end

    end

  end

end
