# frozen_string_literal: true

require "mem"

module Apullo
  class << self
    include Mem

    def fingerprints
      []
    end
    memoize :fingerprints
  end

  class Error < StandardError; end
end

require "apullo/version"

require "apullo/target"
require "apullo/hash"
require "apullo/fingerprints/base"

require "apullo/fingerprints/http"
require "apullo/fingerprints/domain"
require "apullo/fingerprints/ssh"
require "apullo/fingerprints/favicon"

require "apullo/cli"
