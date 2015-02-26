module TheGoogle

  class Calendar

    attr_accessor :name, :access_role, :id

    def self.build_all_from api_output, perspective
      api_output.data.items.map do |item|
        new.tap do |c|
          c.name        = item.summary
          c.access_role = item.access_role
          c.id          = item.id
        end
      end
    end

  end

end
