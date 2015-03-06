module TheGoogle

  class Perspective

    attr_reader :config

    def initialize config
      @config = HashWithIndifferentAccess.new config
    end

    def client
      Google::APIClient.new.tap do |api_client|
        api_client.authorization.tap do |a|
          a.client_id     = config[:client_id]
          a.client_secret = config[:client_secret]
          a.scope         = config[:scope]
          a.refresh_token = config[:refresh_token]
          a.access_token  = config[:access_token]

          a.fetch_access_token! if a.refresh_token && a.expired?
        end
      end
    end

    def calendars
      api_method = calendar_service.calendar_list.list
      data       = client.execute(api_method: api_method)
      TheGoogle::Calendar.build_all_from data, self
    end

    def calendar_service
      client.discovered_api 'calendar', 'v3'
    end

  end

end
