# frozen_string_literal: true

require "json"
require "parallel"
require "thor"

module Apullo
  class CLI < Thor
    desc "check [Target]", "Take fingerprints from a target(IP, domain or URL)"
    def check(target)
      target = Target.new(target)

      results = build_results(target)
      meta = { target: target.id }
      results = results.merge(meta: meta)

      puts JSON.pretty_generate(results)
    end

    no_commands do
      def build_results(target)
        unless target.valid?
          return {
            error: "Invalid target is given. Target should be an IP, domain or URL."
          }
        end

        Parallel.map(Apullo.fingerprints) do |klass|
          fingerprint = klass.new(target)
          [fingerprint.name, fingerprint.results]
        end.to_h
      end
    end
  end
end
