# frozen_string_literal: true

require "addressable/uri"
require "ipaddr"
require "public_suffix"
require "resolv"

module Apullo
  class Target
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def ipv4
      @ipv4 ||= resolve
    end

    def host
      @host ||= uri&.host
    end

    def scheme
      @scheme ||= uri&.scheme
    end

    def url
      @url ||= uri&.to_s
    end

    def uri
      @uri ||= Addressable::URI.parse(_url)
    rescue Addressable::URI::InvalidURIError => _e
      nil
    end

    def valid?
      uri && (ip? | domain?)
    end

    def ip?
      IPAddr.new host
      true
    rescue IPAddr::InvalidAddressError => _e
      false
    end

    def domain?
      return false if host.match? /[0-9]\z/

      PublicSuffix.valid?(host, default_rule: nil)
    end

    private

    def _url
      @_url ||= id.start_with?("http://", "https://") ? id : "http://#{id}"
    end

    def resolve
      Resolv.getaddress uri&.host
    rescue Resolv::ResolvError => _e
      nil
    end
  end
end
