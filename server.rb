require_relative './lib/oncall'
require 'sinatra/base'
require 'rack-cache'
require 'dalli'

OnCall.configure do |o|
  o.groups = {
    team_one: [
      ENV.fetch('TEAM_ONE_PRIMARY'),
      ENV.fetch('TEAM_ONE_SECONDARY')
    ],
    team_two: [
      ENV.fetch('TEAM_TWO')
    ]
  }
  o.pager_token = ENV.fetch('PAGER_TOKEN')
  o.pager_url   = ENV.fetch('PAGER_URL')
end

class OnCall::Server < Sinatra::Base

  CACHE_EXPIRES = ENV.fetch('RACK_CACHE_TIME', 5) # 5 seconds

  configure :production do
    require 'newrelic_rpm'
  end

  before do
    cache_control :public, :must_revalidate, max_age: CACHE_EXPIRES
  end

  set :static_cache_control, [:public, :max_age => 120]

  get '/' do
    @users = OnCall::Users.all
    erb :now
  end

  get '/now' do
    content_type :json
    OnCall::Users.all.to_json
  end

end
