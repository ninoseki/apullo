# frozen_string_literal: true

RSpec.describe Apullo::Fingerprint::Domain do
  subject { described_class.new target }

  let(:id) { "example.com" }
  let(:target) { Apullo::Target.new id }

  describe "#results" do
    let(:results) { subject.results }

    it do
      [:whois, :dns].each do |key|
        expect(results.dig(key)).to be_a(Hash)
      end

      expect(results.dig(:meta, :links, :securitytrails)).to eq("https://securitytrails.com/domain/example.com/dns")
    end
  end
end
