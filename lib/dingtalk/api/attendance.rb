module Dingtalk
  module Api
    class Attendance < Base
      def list(params)
        http_post('/list', params)
      end

      private
      def base_url
        '/attendance'
      end
    end
  end
end
