require_relative '../spec_helper'

describe TheGoogle::Calendar do

  #result.data.items.first
  #<Google::APIClient::Schema::Calendar::V3::CalendarListEntry:0x3ff53b6cc01c DATA:{"kind"=>"calendar#calendarListEntry", "etag"=>"\"1524894352006000\"", "id"=>"an@email.address", "summary"=>"the calendar name", "timeZone"=>"America/Chicago", "colorId"=>"17", "backgroundColor"=>"#9a9cff", "foregroundColor"=>"#000000", "selected"=>true, "accessRole"=>"owner", "defaultReminders"=>[{"method"=>"popup", "minutes"=>10}], "notificationSettings"=>{"notifications"=>[{"type"=>"eventCreation", "method"=>"email"}, {"type"=>"eventChange", "method"=>"email"}, {"type"=>"eventCancellation", "method"=>"email"}, {"type"=>"eventResponse", "method"=>"email"}]}, "primary"=>true}>

  describe "build all from" do

    let(:api_output) { Struct.new(:data).new(Struct.new(:items).new(items)) }

    describe "there are two calendars" do

      let(:items) do
        [
          [random_string, random_string, random_string],
          [random_string, random_string, random_string],
        ].map { |x| Struct.new(:summary, :access_role, :id).new *x }
      end

      let(:results) { TheGoogle::Calendar.build_all_from api_output }

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

    end

  end

end
