# frozen_string_literal: true

require "ssh_scan"

module Apullo
  module Fingerprint
    class SSH < Base
      DEFAULT_OPTIONS = { "timeout" => 3 }.freeze
      DEFAULT_PORTS = [22, 2222].freeze

      private

      def build_results
        pluck_fingerprints
      end

      def pluck_fingerprints
        result = scan
        keys = result.dig("keys") || {}
        keys.map do |cipher, data|
          raw = data.dig("raw")
          fingerprints = data.dig("fingerprints") || []
          normalized_fingerprints = fingerprints.map do |hash, value|
            [hash, value.delete(":")]
          end.to_h
          [
            cipher,
            { raw: raw, fingerprints: normalized_fingerprints }
          ]
        end.to_h
      end

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
    end
  end
end
