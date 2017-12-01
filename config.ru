require 'dotenv'
Dotenv.load

require './server'

# Defined in ENV on Heroku. To try locally, start memcached and uncomment:
# ENV["MEMCACHIER_SERVERS"] = "localhost"
if memcache_servers = ENV["MEMCACHIER_SERVERS"]
  cache = Dalli::Client.new memcache_servers.split(','), {
    username: ENV['MEMCACHIER_USERNAME'],
    password: ENV['MEMCACHIER_PASSWORD']
  }
  use Rack::Cache, verbose: true, metastore: cache, entitystore: cache
end

use Rack::Deflater

run OnCall::Server