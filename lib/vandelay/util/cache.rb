require 'redis'

module Vandelay
  module Util
    class Cache

      def self.fetch(key)
        Vandelay.redis.get(key)
      end

      def self.set(key, data, expiry=600)
        Vandelay.redis.setex(key, expiry, data)
      end
    end
  end
end
