module Dingtalk
  module Api
    class Department < Base
      def list
        http_get('/list')
      end

      def get(id)
        http_get('/get', {id: id})
      end

      def create(params)
        http_post('/create', params)
      end

      def update(params)
        http_post('/update', params)
      end

      def delete(id)
        http_get('/delete', {id: id})
      end

      private
      def base_url
        '/department'
      end
    end
  end
end
