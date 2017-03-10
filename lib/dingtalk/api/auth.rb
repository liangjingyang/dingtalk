module Dingtalk
  module Api
    class Auth < Base
      def get_token(corp_id, corp_secret)
        params = {
          corpid: corp_id,
          corpsecret: corp_secret 
        }
        res = RestClient.get(request_url("/gettoken"), {params: params})
        res = JSON.parse(res)
        res['access_token']
      end

      def get_ticket()
        params = {
          type: 'jsapi',
        }
        res = http_get("/get_jsapi_ticket", params)
        res['ticket']
      end
    end
  end
end