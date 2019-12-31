# frozen_string_literal: true

require "ssh_scan"

module Apullo
  module Fingerprint
    class SSH < Base
      DEFAULT_OPTIONS = { "timeout" => 3 }.freeze
      DEFAULT_PORT = 22

      private

      def build_results
        pluck_fingerprints
      end

      def pluck_fingerprints
        result = scan
        keys = result.dig("keys") || []
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

      def scan
        return {} unless target.host

        engine = SSHScan::ScanEngine.new
        dest = "#{target.host}:#{DEFAULT_PORT}"
        result = engine.scan_target(dest, DEFAULT_OPTIONS)
        result.to_hash
      end
    end
  end
end
