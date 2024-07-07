require 'json'
require 'uri'
require 'net/http'
require 'redis'
require 'vandelay/util/cache'

module Vandelay
  module Integrations
    class Base

      def fetch_url(server)
        'http://'+Vandelay.config["integrations"]["vendors"]["#{server}"]["api_base_url"]
      end

      def fetch_access_token(server)
        auth_url = Vandelay.config["integrations"]["vendors"]["#{server}"]["auth_url"]
        uri = URI(fetch_url(server)+auth_url+'/1') # using 1 as static for now, can be passed in parameter when dynamic
        response = Net::HTTP.get_response(uri)
        token_key = server == 'one' ? 'token' : 'auth_token'
        JSON.parse(response.body)[token_key]
      end

      def fetch_api(record_id, server)
        return {} if server.nil? || server == ''
        # fetch cached response from redis via key
        cached_record = Vandelay::Util::Cache.fetch("record_#{record_id}_#{server}")
        if cached_record.nil?
          token = fetch_access_token(server)
          api_url = Vandelay.config["integrations"]["vendors"]["#{server}"]["api_url"]
          uri = URI(fetch_url(server)+api_url+"/"+record_id)
          header = {}
          header['Authorization'] = "Bearer #{token}" unless token.nil? || token.empty?
          response = Net::HTTP.get_response(uri, header)
          data = response.body
          puts "We hit the mock server #{server}, not from cache"

          # Cache response in Redis for 10 minutes
          Vandelay::Util::Cache.set("record_#{record_id}_#{server}", data, 600)  # 600 seconds = 10 minutes

          cached_record = data
        end
        JSON.parse(cached_record)
      end
    end
  end
end
