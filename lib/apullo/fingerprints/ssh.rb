# frozen_string_literal: true

require "mem"
require "ssh_scan"
require "uri"

module Apullo
  module Fingerprint
    class SSH < Base
      include Mem

      DEFAULT_OPTIONS = { "timeout" => 3 }.freeze
      DEFAULT_PORTS = [22, 2222].freeze

      private

      def build_results
        results = fingerprints
        results = results.merge(meta: { links: links }) unless results.empty?
        results
      end

      def fingerprints
        result = scan
        keys = result.dig("keys") || {}
        keys.map do |cipher, data|
          fingerprints = data.dig("fingerprints") || []
          normalized_fingerprints = fingerprints.map do |hash, value|
            [hash, value.delete(":")]
          end.to_h
          [
            cipher,
            normalized_fingerprints
          ]
        end.to_h
      end
      memoize :fingerprints

      def _scan(target, port: 22)
        return nil unless target.host

        engine = SSHScan::ScanEngine.new
        dest = "#{target.host}:#{port}"
        result = engine.scan_target(dest, DEFAULT_OPTIONS)
        result.to_hash
      end

      def scan
        [target].product(DEFAULT_PORTS).each do |target, port|
          result = _scan(target, port: port)
          keys = result.dig("keys") || {}
          return result unless keys.empty?
        end
        {}
      end

      def shodan_link
        uri = URI("https://www.shodan.io/search")
        fingerprint = fingerprints.dig("rsa", "md5") || fingerprints.dig("ecdsa-sha2-nistp256", "md5")
        return nil unless fingerprint

        fingerprint = fingerprint.to_s.chars.each_slice(2).map(&:join).join(":")
        uri.query = URI.encode_www_form(query: "port:22 #{fingerprint}")
        uri.to_s
      end

      def censys_link
        uri = URI("https://censys.io/ipv4")
        fingerprint = fingerprints.dig("ecdsa-sha2-nistp256", "sha256") || fingerprints.dig("rsa", "sha256")
        return nil unless fingerprint

        uri.query = URI.encode_www_form(q: fingerprint.to_s)
        uri.to_s
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
