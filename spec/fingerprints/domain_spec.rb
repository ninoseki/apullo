# frozen_string_literal: true

RSpec.describe Apullo::Fingerprint::Domain, :vcr do
  subject { described_class.new target }

  let(:id) { "example.com" }
  let(:target) { Apullo::Target.new id }

  describe "#results" do
    it do
      results = subject.results

      [:whois, :dns].each do |key|
        expect(results.dig(key)).to be_a(Hash)
      end
    end
  end
end
