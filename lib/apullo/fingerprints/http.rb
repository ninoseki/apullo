# frozen_string_literal: true

require "mem"
require "net/http"
require "oga"
require "openssl"
require "uri"

module Apullo
  module Fingerprint
    class HTTP < Base
      include Mem

      attr_writer :headers

      def initialize(target)
        super target

        @headers = {}
      end

      private

      def build_results
        get(target.uri.path)

        {
          body: body,
          cert: cert,
          favicon: favicon,
          headers: response_headers,
          meta: {
            url: target.url,
            links: links
          }
        }
      end

      def cert
        return {} unless @peer_cert

        hash = Hash.new(@peer_cert.to_der)
        {
          md5: hash.md5,
          serial: @peer_cert.serial.to_i,
          sha1: hash.sha1,
          sha256: hash.sha256,
        }
      end
      memoize :cert

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
      memoize :body

      def favicon
        url = favicon_url
        return {} unless url

        favicon = Favicon.new(url)
        favicon.results
      end
      memoize :favicon

      def response_headers
        @response_headers || {}
      end

      def headers
        @headers.compact
      end

      def default_favicon_url
        "#{target.uri.scheme}://#{target.uri.host}:#{target.uri.port}/favicon.ico"
      end

      def build_doc
        Oga.parse_html(@body)
      rescue ArgumentError, LL::ParserError => _e
        nil
      end

      def favicon_url
        return nil unless @body

        doc = build_doc
        return nil unless doc

        icon = doc.at_css("link[rel='shortcut icon']") || doc.at_css("link[rel='icon']")
        return default_favicon_url unless icon

        href = icon.get("href")
        return default_favicon_url unless href

        return href if href.start_with?("http://", "https://")

        target.url.end_with?("/") ? target.url + href : "#{target.url}/#{href}"
      end

      def get(path, limit: 3)
        http = build_http
        path = path.empty? ? "/" : path
        request = Net::HTTP::Get.new(path, headers)
        response = http.request request

        location = response["Location"]
        if location && limit.positive?
          if location.start_with?("http://", "https://")
            rebuild_target location
            get(target.uri.path)
          else
            get(location, limit: limit - 1)
          end
        else
          @peer_cert = http.peer_cert
          @body = response.body
          @response_headers = response.each_header.to_h
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

      def rebuild_target(url)
        @target = Target.new(url)
      end

      def shodan_link
        uri = URI("https://www.shodan.io/search")
        uri.query = URI.encode_www_form(query: "http.html_hash:#{body.dig(:mmh3)}")
        body_link = body.empty? ? nil : uri.to_s

        uri.query = URI.encode_www_form(q: "ssl.cert.serial:#{cert.dig(:serial)}")
        cert_link = cert.empty? ? nil : uri.to_s

        uri.query = URI.encode_www_form(query: "http.favicon.hash:#{favicon.dig(:mmh3)}")
        favicon_link = favicon.empty? ? nil : uri.to_s

        { body: body_link, cert: cert_link, favicon: favicon_link }.compact
      end

      def censys_link
        uri = URI("https://censys.io/ipv4")
        uri.query = URI.encode_www_form(q: body.dig(:sha256))
        body_link = body.empty? ? nil : uri.to_s

        uri.query = URI.encode_www_form(q: cert.dig(:sha256))
        cert_link = cert.empty? ? nil : uri.to_s

        { body: body_link, cert: cert_link }.compact
      end

      def links
        {
          shodan: shodan_link,
          censys: censys_link
        }
      end
    end
  end
end
