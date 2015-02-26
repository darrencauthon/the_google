module TheGoogle

  class Perspective

    attr_reader :config

    def initialize config
      @config = HashWithIndifferentAccess.new config
    end

    def client
      Google::APIClient.new.tap do |a|
        a.authorization.client_id = config[:client_id]
        a.authorization.client_secret = config[:client_secret]
        a.authorization.scope = config[:scope]
        a.authorization.refresh_token = config[:refresh_token]
        a.authorization.access_token = config[:access_token]
        if a.authorization.refresh_token && a.authorization.expired?
          a.authorization.fetch_access_token!
        end
      end
    end

    def calendars
      api_method = calendar_service.calendar_list.list
      data = client.execute(api_method: api_method)
      TheGoogle::Calendar.build_all_from data
    end

    def calendar_service
      client.discovered_api 'calendar', 'v3'
    end

  end

end
