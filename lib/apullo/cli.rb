# frozen_string_literal: true

require "json"
require "thor"

module Apullo
  class CLI < Thor
    desc "check [Target]", "Take fingerprints from a target(IP, domain or URL)"
    method_option :headers, type: :hash, default: {}
    def check(target)
      target = Target.new(target)
      headers = options["headers"]

      results = build_results(target, headers: headers)
      meta = { target: target.id }
      results = results.merge(meta: meta)

      puts JSON.pretty_generate(results)
    end

    no_commands do
      def build_results(target, headers: {})
        unless target.valid?
          return {
            error: "Invalid target is given. Target should be an IP, domain or URL."
          }
        end

        Apullo.fingerprints.map do |klass|
          fingerprint = klass.new(target)
          fingerprint.headers = headers if fingerprint.respond_to?(:headers=)

          [fingerprint.name, fingerprint.results]
        end.to_h
      end
    end
  end
end
