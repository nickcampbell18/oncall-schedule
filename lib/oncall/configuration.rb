module OnCall

  class << self
    attr_accessor :config

    def adapter
      @adapter ||= Faraday.new url: OnCall.config.pager_url do |f|
        f.token_auth OnCall.config.pager_token
        f.adapter :typhoeus
        f.response :logger
      end
    end
  end

  def self.configure
    self.config ||= Config.new
    yield(config)
  end

  class Config
    attr_accessor :groups, :pager_token, :pager_url

    def initialize
      @groups = {}
    end

  end

end