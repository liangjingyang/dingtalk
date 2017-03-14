require "dingtalk/version"
require "dingtalk/config"
require "dingtalk/pkcs7_encoder"
require "dingtalk/prpcrypt"
require "dingtalk/api"
require "dingtalk/client"
require "dingtalk/robot"

require "rest-client"

module Dingtalk
  ENDPOINT = "https://oapi.dingtalk.com"
end
