# frozen_string_literal: true

RSpec.describe Apullo::Fingerprint::HTTP, :vcr do
  subject { described_class.new target }

  let(:id) { "example.com" }
  let(:target) { Apullo::Target.new id }

  describe "#results" do
    it do
      results = subject.results

      expect(results.keys).to eq([:body, :cert, :favicon, :meta])

      [:md5, :sha1, :sha256, :mmh3].each do |key|
        expect(results.dig(:body, key)).to be_a(String).or be_a(Integer)
      end

      [:md5, :sha1, :sha256, :serial].each do |key|
        expect(results.dig(:cert, key)).to eq(nil)
      end
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
