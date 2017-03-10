module Dingtalk
  module Api
    class Message < Base
      def send_to_conversation(params)
        http_post('/send_to_conversation', params)
      end

      def send(params)
        http_post('/send', params)
      end

      private
      def base_url
        '/message'
      end
    end
  end
end
