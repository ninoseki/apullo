# frozen_string_literal: true

require "net/http"
require "openssl"
require "base64"

module Apullo
  module Fingerprint
    class Favicon
      attr_reader :uri

      def initialize(url)
        @uri = URI(url)
      end

      def results
        data = b64_favicon_data
        return {} unless data

        hash = Hash.new(data.b)
        {
          md5: hash.md5,
          mmh3: hash.mmh3,
          sha1: hash.sha1,
          sha256: hash.sha256,
          meta: {
            url: uri.to_s
          }
        }
      end

      private

      def b64_favicon_data
        @b64_favicon_data ||= [].tap do |out|
          data = get(uri.path)
          break unless data

          b64 = Base64.strict_encode64(data)
          out << b64.chars.each_slice(76).map(&:join).join("\n") + "\n"
        end.first
      end

      def get(path)
        http = build_http
        path = path.empty? ? "/" : path
        request = Net::HTTP::Get.new(path)
        response = http.request(request)
        response.body
      rescue Errno::ECONNREFUSED, Net::HTTPError, OpenSSL::OpenSSLError => _e
        nil
      end

      def build_http
        if uri.scheme == "http"
          Net::HTTP.start(uri.host, uri.port)
        else
          Net::HTTP.start(uri.host, uri.port, use_ssl: true)
        end
      end
    end
  end
end
