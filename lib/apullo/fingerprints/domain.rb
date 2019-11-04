# frozen_string_literal: true

require "resolv"
require "whois-parser"

module Apullo
  module Fingerprint
    class Domain < Base
      RESOURCES = [
        Resolv::DNS::Resource::IN::NS,
        Resolv::DNS::Resource::IN::CNAME,
        Resolv::DNS::Resource::IN::SOA,
        Resolv::DNS::Resource::IN::MX,
        Resolv::DNS::Resource::IN::A,
        Resolv::DNS::Resource::IN::AAAA,
      ].freeze

      def results
        {
          dns: resources,
          whois: contacts,
        }
      end

      private

      def dns
        @dns ||= Resolv::DNS.new
      end

      def resources
        @resources ||= RESOURCES.map do |resource|
          name = resource.to_s.split("::").last.to_s.downcase
          values = resolve(resource)
          [name, values]
        end.to_h
      end

      def resolve(resource)
        ress = dns.getresources(target.host, resource)
        values = ress.map do |res|
          if res.respond_to?(:address)
            res.address.to_s
          elsif res.respond_to?(:exchange)
            res.exchange.to_s
          elsif res.respond_to?(:name)
            res.name.to_s
          elsif res.respond_to?(:rname)
            res.rname.to_s
          end
        end.compact
        values.reject(&:empty?).empty? ? [] : values
      end

      def whois_client
        @whois_client ||= Whois::Client.new(timeout: 3)
      end

      def whois
        @whois ||= whois_client.lookup(target.host)
      rescue Timeout::Error, Whois::Error
        nil
      end

      def registrant_contacts
        whois&.parser&.registrant_contacts&.map(&:to_h)
      rescue Whois::ParserError => _e
        []
      end

      def admin_contacts
        whois&.parser&.admin_contacts&.map(&:to_h)
      rescue Whois::ParserError => _e
        []
      end

      def technical_contacts
        whois&.parser&.technical_contacts&.map(&:to_h)
      rescue Whois::ParserError => _e
        []
      end

      def contacts
        return {} unless whois

        {
          registrant_contacts: registrant_contacts,
          admin_contacts: admin_contacts,
          technical_contacts: technical_contacts
        }
      end
    end
  end
end
