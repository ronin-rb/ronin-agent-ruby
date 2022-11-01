require 'net/http'

module Agent
  module Transports
    class HTTP

      include Message

      attr_reader :host

      attr_reader :port

      def initialize(host,port=80)
        @host = host
        @port = port
      end

      def self.start(host,port=80)
        new(host,port).start
      end

      def start
        serve
      end

      def serve
        loop do
          poll do |request|
            name, arguments = *request

            push(RPC.call(name,arguments))
          end

          sleep 2
        end
      end

      def poll
        Net::HTTP.start(host,port) do |http|
          response = http.get('/requests')
          
          if response.code == '200'
            yield decode_request(response.body)
          end
        end
      end

      def push(value)
        Net::HTTP.start(@host,@port) do |http|
          http.post('/response',encode_response(value))
        end
      end

    end
  end
end
