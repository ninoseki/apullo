# frozen_string_literal: true

RSpec.describe Apullo::Fingerprint::Favicon, :vcr do
  subject { described_class.new url }

  let(:url) { "https://www.w3.org/2008/site/images/favicon.ico" }

  describe "#results" do
    it do
      results = subject.results
      [:md5, :sha1, :sha256, :mmh3].each do |key|
        expect(results.dig(key)).to be_a(String).or be_a(Integer)
      end
    end
  end
end
