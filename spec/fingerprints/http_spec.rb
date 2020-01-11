# frozen_string_literal: true

RSpec.describe Apullo::Fingerprint::HTTP, :vcr do
  subject { described_class.new target }

  let(:id) { "example.com" }
  let(:target) { Apullo::Target.new id }

  describe "#results" do
    let(:results) { subject.results }

    it do
      expect(results.keys).to eq([:body, :cert, :favicon, :headers, :meta])

      [:md5, :sha1, :sha256, :mmh3].each do |key|
        expect(results.dig(:body, key)).to be_a(String).or be_a(Integer)
      end

      [:md5, :sha1, :sha256, :serial].each do |key|
        expect(results.dig(:cert, key)).to eq(nil)
      end

      expect(results.dig(:meta, :links, :shodan, :body)).to eq("https://www.shodan.io/search?query=http.html_hash%3A-2087618365")
      expect(results.dig(:meta, :links, :censys, :body)).to eq("https://censys.io/ipv4?q=ea8fac7c65fb589b0d53560f5251f74f9e9b243478dcb6b3ea79b5e36449c8d9")
    end

    context "when given headers" do
      it do
        subject.headers = { "User-Agent": "foo" }
        results = subject.results
        expect(results).to be_a(Hash)
      end
    end
  end
end
