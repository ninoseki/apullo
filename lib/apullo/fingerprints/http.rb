# frozen_string_literal: true

require "net/http"
require "oga"
require "openssl"

module Apullo
  module Fingerprint
    class HTTP < Base
      def results
        @results ||= [].tap do |out|
          get(target.uri.path)

          out << {
            body: body,
            cert: cert,
            favicon: favicon
          }
        end.first
      end

      def cert
        return {} unless @peer_cert

        hash = Hash.new(@peer_cert.to_der)
        {
          md5: hash.md5,
          serial: @peer_cert.serial,
          sha1: hash.sha1,
          sha256: hash.sha256,
        }
      end

      def body
        return {} unless @body

        hash = Hash.new(@body)
        {
          md5: hash.md5,
          mmh3: hash.mmh3,
          sha1: hash.sha1,
          sha256: hash.sha256,
        }
      end

      def favicon
        url = favicon_url
        return {} unless url

        favicon = Favicon.new(url)
        favicon.results
      end

      private

      def default_favicon_url
        "#{target.uri.scheme}://#{target.uri.host}:#{target.uri.port}/favicon.ico"
      end

      def favicon_url
        return nil unless @body

        doc = Oga.parse_html(@body)
        icon = doc.at_css("link[rel='shortcut icon']") || doc.at_css("link[rel='icon']")
        return default_favicon_url unless icon

        href = icon.get("href")
        return default_favicon_url unless href

        href.start_with?("http://", "https://") ? href : target.url + href
      end

      def get(path, limit: 3)
        http = build_http
        path = path.empty? ? "/" : path
        request = Net::HTTP::Get.new(path)
        response = http.request request

        location = response["Location"]
        if location && limit.positive?
          get(location, limit: limit - 1)
        else
          @peer_cert = http.peer_cert
          @body = response.body
          @path = path
        end
      rescue Errno::ECONNREFUSED, Net::HTTPError, OpenSSL::OpenSSLError, Timeout::Error => _e
        nil
      end

      def build_http
        if target.scheme == "http"
          Net::HTTP.start(target.uri.host, target.uri.port)
        else
          Net::HTTP.start(target.uri.host, target.uri.port, use_ssl: true)
        end
      end
    end
  end
end
