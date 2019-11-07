# frozen_string_literal: true

module Apullo
  module Fingerprint
    class Base
      attr_reader :target

      def initialize(target)
        @target = target
        @results = nil
      end

      def name
        self.class.to_s.split("::").last.to_s.downcase
      end

      def results
        return @results if @results

        with_error_handling do
          @results ||= build_results
        end
        @results
      end

      private

      def with_error_handling
        yield
      rescue StandardError => e
        @results = { error: e.to_s }
      end

      def build_results
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      class << self
        def inherited(child)
          Apullo.fingerprints << child
        end
      end
    end
  end
end
