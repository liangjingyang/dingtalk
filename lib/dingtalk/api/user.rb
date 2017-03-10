module Dingtalk
  module Api
    class User < Base
      def get_userid_by_unionid(unionid)
        http_get('/getUseridByUnionid', {unionid: unionid})
      end

      def get(userid)
        http_get('/get', {userid: userid})
      end

      def create(name, mobile, department = [1])
        params = {
          name: name,
          mobile: mobile,
          department: department
        }
        http_post('/create', params)
      end

      def update(params)
        http_post('/update', params)
      end

      def delete(userid)
        http_post('/delete', {userid: userid})
      end

      def batchdelete(useridlist)
        http_post('/batchdelete', {useridlist: useridlist})
      end
      
      def simplelistd(department_id)
        http_get('/simplelist', {department_id: department_id})
      end
      
      def list(department_id)
        http_get('/list', {department_id: department_id})
      end

      def get_admin(department_id)
        http_get('/get_admin', {deparment_id: department_id})
      end

      def get_org_user_count(onlyActive)
        http_get('/get_org_user_count', {onlyActive: onlyActive})
      end

      def getuserinfo(code)
        http_get('/getuserinfo', {code: code})
      end

      private
      def base_url
        '/user'
      end
    end
  end
end

