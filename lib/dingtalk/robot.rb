module Dingtalk
  class Robot 
    def self.send(robot_url, payload)
      res = RestClient.post(robot_url, payload.to_json, content_type: :json)
      JSON.parse(res)
    end
  end
end
