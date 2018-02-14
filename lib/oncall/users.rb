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
        c.url "/schedules/#{id}/users"
        c.params = { since: minute_ago,
                     until: current_time }
      end
    end

    def self.from_entries(hash)
      entries = JSON.parse(hash).fetch('users')
      entries.fetch(0, {})
    end

    def self.current_time
      URI.escape Time.now.iso8601
    end

    def self.minute_ago
      URI.escape (Time.now - 60).iso8601
    end
  end

end
