module Dingtalk
  class Client

    attr_reader :instance_options, :attendance, :auth, :department, :message, :user
    attr_accessor :access_token, :access_token_expire, :jsapi_ticket, :jsapi_ticket_expire
    attr_accessor :access_token_expire_time, :jsapi_ticket_expire_time

    def initialize(options = {})
      @instance_options = options.inject({}) { |memo,(k,v) | memo[k.to_sym] = v; memo }
      @instance_options[:corp_id] ||= Dingtalk.corp_id
      @instance_options[:corp_secret] ||= Dingtalk.corp_secret
      @instance_options[:agentid] ||= Dingtalk.agentid
      @instance_options[:suite_key] ||= Dingtalk.suite_key
      @instance_options[:suite_secret] ||= Dingtalk.suite_secret
      @instance_options[:suite_aes_key] ||= Dingtalk.suite_aes_key
      @instance_options[:suite_token] ||= Dingtalk.suite_token
      @auth = Api::Auth.new(self)
      @attendance = Api::Attendance.new(self)
      @department = Api::Department.new(self)
      @message = Api::Message.new(self)
      @user = Api::User.new(self)
      @access_token_expire = true
      @jsapi_ticket_expire = true
    end

    def get_access_token
      now = Time.now.to_i
      expired = access_token_expire && (access_token_expire_time.to_i + 3600 < now.to_i ? true : false)
      return access_token unless expired
      access_token = auth.get_token(instance_options[:corp_id], instance_options[:corp_secret])
      access_token_expire_time = now if access_token.present?
      access_token
    end

    def get_jsapi_ticket
      now = Time.now.to_i
      expired = jsapi_ticket_expire && (jsapi_ticket_expire_time.to_i + 3600 < now.to_i ? true : false) 
      return jsapi_ticket unless expired
      jsapi_ticket = auth.get_ticket
      jsapi_ticket_expire_time = now if jsapi_ticket.present?
      jsapi_ticket
    end

    # for suite
    def set_access_token(token, expire = true)
      @access_token = token
      @access_token_expire = expire
    end

    # for suite
    def set_jsapi_ticket(ticket, expire = true)
      @jsapi_ticket = ticket
      @jsapi_ticket_expire = expire
    end

    def decrypt(echo_str)
      content = Dingtalk::Prpcrypt.decrypt(aes_key, echo_str, instance_options[:suite_key])
      JSON.parse(content)
    end

    def response_json(return_str)
      the_timestamp = timestamp
      the_nonce = nonce
      encrypted = encrypt(return_str)
      {
        msg_signature: signature(return_str, encrypted, the_timestamp, the_nonce),
        encrypt: encrypted,
        timeStamp: the_timestamp,
        nonce: the_nonce
      }
    end

    def encrypt(return_str)
      encrypt = Dingtalk::Prpcrypt.encrypt(aes_key, return_str, instance_options[:suite_key])
    end

    def signature(return_str, encrypted, the_timestamp, the_nonce)
      sort_params = [instance_options[:suite_token], the_timestamp, the_nonce, encrypted].sort.join
      Digest::SHA1.hexdigest(sort_params)
    end

    def jssign_package(request_url)
      the_timestamp = timestamp
      the_nonce = nonce
      str = "jsapi_ticket=#{base.js_ticket}&noncestr=#{the_nonce}&timestamp=#{the_timestamp}&url=#{CGI.unescape(request_url)}"
      signature = Digest::SHA1.hexdigest(str)
      {
        js_ticket: base.js_ticket,
        request_url: request_url,
        corp_id: instance_options[:corp_id],
        timeStamp: the_timestamp,
        nonceStr: the_nonce,
        signature: signature
      }
    end
    
    private
    def aes_key
      Base64.decode64(instance_options[:suite_aes_key] + '=')
    end

    def timestamp
      Time.now.to_i.to_s
    end

    def nonce
      SecureRandom.hex
    end
  end
end
