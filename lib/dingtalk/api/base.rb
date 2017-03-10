module Dingtalk
  module Api
    class Base
      def initialize(client = nil)
        @client = client
      end


      def get_access_token
        @client.get_access_token if @client
      end

      def get_jsapi_ticket
        @client.get_jsapi_ticket if @client
      end

      def default_params
        { access_token: get_access_token }
      end

      def http_get(url, params = {})
        params = default_params.merge(params)
        res = RestClient.get(request_url(url), {params: params})
        JSON.parse(res)
      end

      def http_post(url, payload, params = {})
        params = default_params.merge(params)
        res = RestClient.post(request_url(url), payload.to_json, {content_type: :json, params: params})
        JSON.parse(res)
      end

      def base_url
        ''
      end

      def request_url(url)
        "#{ENDPOINT}#{base_url}#{url}"
      end
    end
  end
end
