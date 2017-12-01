require 'time'
require 'uri'

module OnCall
  class Users

    def self.all
      results = {}

      OnCall.adapter.in_parallel do
        OnCall.config.groups.each do |name, ids|
          ids = Array(ids) # can be an array of primary, secondary etc
          results[name] = ids.map {|i| http_call(i) }
        end
      end

      return results.inject({}) do |h, (name, responses)|
        h[name] = []
        responses.each_with_index do |response, index|
          h[name] << from_entries(response.body)['name']
        end
        h
      end

    end

    def self.http_call(id)
      OnCall.adapter.get do |c|
        c.url "/api/v1/schedules/#{id}/entries"
        c.params = { since: current_time,
                     until: current_time,
                     overflow: true }
      end
    end

    def self.from_entries(hash)
      entries = JSON.parse(hash).fetch('entries')
      entries.fetch(0, {}).fetch('user', {})
    end

    def self.current_time
      URI.escape Time.now.iso8601
    end

  end

end