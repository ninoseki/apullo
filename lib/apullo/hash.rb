# frozen_string_literal: true

require "digest/sha2"
require "murmurhash3"

module Apullo
  class Hash
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def sha1
      Digest::SHA1.hexdigest data
    end

    def sha256
      Digest::SHA256.hexdigest data
    end

    def md5
      Digest::MD5.hexdigest data
    end

    def mmh3
      hash = MurmurHash3::V32.str_hash(data)
      if (hash & 0x80000000).zero?
        hash
      else
        -((hash ^ 0xFFFFFFFF) + 1)
      end
    end
  end
end
