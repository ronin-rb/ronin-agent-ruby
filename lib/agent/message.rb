require 'base64'
require 'json'

module Agent
  module Message
    protected

    def serialize(data);   Base64.encode64(data.to_json);     end
    def deserialize(data); JSON.parse(Base64.decode64(data)); end

    def decode_request(request)
      request = deserialize(request)

      return request['name'], request.fetch('arguments',[])
    end

    def encode_response(response); serialize(response); end
  end
end
