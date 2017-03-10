module Dingtalk
  class << self
    attr_accessor :config

    def configure
      yield self.config ||= Config.new
    end

    def suite_key
      @suite_key ||= config.suite_key
    end

    def suite_secret
      @suite_secret ||= config.suite_secret
    end

    def suite_aes_key
      @suite_aes_key ||= config.suite_aes_key
    end

    def suite_token
      @suite_token ||= config.suite_token
    end

    def sns_app_id
      @sns_app_id ||= config.sns_app_id
    end

    def sns_app_secret
      @sns_app_secret ||= config.sns_app_secret
    end

    def corp_id
      @corp_id ||= config.corp_id
    end

    def corp_secret
      @corp_secret ||= config.corp_secret
    end

    def agentid 
      @agentid ||= config.agentid
    end
  end

  class Config
    attr_accessor :redis, :suite_key, :suite_secret, :suite_aes_key, :suite_token, :sns_app_id, :sns_app_secret, :corp_id, :corp_secret, :agentid
  end
end
