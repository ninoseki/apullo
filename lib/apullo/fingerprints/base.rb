# frozen_string_literal: true

module Apullo
  module Fingerprint
    class Base
      attr_reader :target

      def initialize(target)
        @target = target
      end

      def name
        self.class.to_s.split("::").last.to_s.downcase
      end

      def results
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
